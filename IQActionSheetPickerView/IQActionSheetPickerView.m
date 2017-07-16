//
// IQActionSheetPickerView.m
// https://github.com/hackiftekhar/IQActionSheetPickerView
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "IQActionSheetPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "IQActionSheetViewController.h"
#import "IQActionSheetToolbar.h"

NSString * const kIQActionSheetAttributesForNormalStateKey = @"kIQActionSheetAttributesForNormalStateKey";
/// Identifies an attributed string of the toolbar title for highlighted state.
NSString * const kIQActionSheetAttributesForHighlightedStateKey = @"kIQActionSheetAttributesForHighlightedStateKey";

@interface IQActionSheetPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) IQActionSheetToolbar *actionToolbar;
@property (nonatomic, strong) IQActionSheetViewController *actionSheetController;

@end

@implementation IQActionSheetPickerView

- (instancetype)initWithTitle:(NSString *)title delegate:(id<IQActionSheetPickerViewDelegate>)delegate
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height = 216 + 44;
    self = [super initWithFrame:rect];
    if (self) {
        //UIToolbar
        {
            [self.actionToolbar.titleButton setTitle:title];
            [self addSubview:self.actionToolbar];
        }
        //UIPickerView
        {
            [self addSubview:self.pickerView];
        }
        //UIDatePicker
        {
            [self addSubview:self.datePicker];
        }
        //Initial settings
        {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.pickerView.frame), CGRectGetMaxY(self.pickerView.frame))];
            [self setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
            
            self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
            self.actionToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
    }
    _delegate = delegate;
    return self;
}

- (void)setActionSheetPickerStyle:(IQActionSheetPickerStyle)actionSheetPickerStyle
{
    _actionSheetPickerStyle = actionSheetPickerStyle;
    switch (actionSheetPickerStyle) {
        case IQActionSheetPickerStyleTextPicker:
            [self.pickerView setHidden:NO];
            [self.datePicker setHidden:YES];
            break;
        case IQActionSheetPickerStyleDatePicker:
            [self.pickerView setHidden:YES];
            [self.datePicker setHidden:NO];
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case IQActionSheetPickerStyleDateTimePicker:
            [self.pickerView setHidden:YES];
            [self.datePicker setHidden:NO];
            [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case IQActionSheetPickerStyleTimePicker:
            [self.pickerView setHidden:YES];
            [self.datePicker setHidden:NO];
            [self.datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
        default:
            break;
    }
}

/**
 *  Set Picker View Background Color
 *
 *  @param pickerViewBackgroundColor Picker view custom background color
 */
- (void)setPickerViewBackgroundColor:(UIColor *)pickerViewBackgroundColor
{
    self.pickerView.backgroundColor = pickerViewBackgroundColor;
}

/**
 *  Set Cancel Button Title Attributes
 *
 *  @param cancelButtonAttributes Cancel Button Title Attributes
 */
- (void)setCancelButtonAttributes:(NSDictionary *)cancelButtonAttributes
{
    id attributesForCancelButtonNormalState = cancelButtonAttributes[kIQActionSheetAttributesForNormalStateKey];
    if (attributesForCancelButtonNormalState != nil && [attributesForCancelButtonNormalState isKindOfClass:[NSDictionary class]]) {
        [self.actionToolbar.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForCancelButtonNormalState forState:UIControlStateNormal];
    }
    id attributesForCancelButtonnHighlightedState = cancelButtonAttributes[kIQActionSheetAttributesForHighlightedStateKey];
    if (attributesForCancelButtonnHighlightedState != nil && [attributesForCancelButtonnHighlightedState isKindOfClass:[NSDictionary class]]) {
        [self.actionToolbar.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForCancelButtonnHighlightedState forState:UIControlStateHighlighted];
    }
}

/**
 *  Set Done Button Title Attributes
 *
 *  @param cancelButtonAttributes Done Button Title Attributes
 */
- (void)setDoneButtonAttributes:(NSDictionary *)doneButtonAttributes
{
    id attributesForDoneButtonNormalState = doneButtonAttributes[kIQActionSheetAttributesForNormalStateKey];
    if (attributesForDoneButtonNormalState != nil && [attributesForDoneButtonNormalState isKindOfClass:[NSDictionary class]]) {
        [self.actionToolbar.doneButton setTitleTextAttributes:(NSDictionary *)attributesForDoneButtonNormalState forState:UIControlStateNormal];
    }
    id attributesForDoneButtonnHighlightedState = doneButtonAttributes[kIQActionSheetAttributesForHighlightedStateKey];
    if (attributesForDoneButtonnHighlightedState != nil && [attributesForDoneButtonnHighlightedState isKindOfClass:[NSDictionary class]]) {
        [self.actionToolbar.doneButton setTitleTextAttributes:(NSDictionary *)attributesForDoneButtonnHighlightedState forState:UIControlStateHighlighted];
    }
}

/**
 *  Set Action Bar Color
 *
 *  @param barColor Custom color for toolBar
 */
- (void)setToolbarTintColor:(UIColor *)toolbarTintColor
{
    _toolbarTintColor = toolbarTintColor;
    [self.actionToolbar setBarTintColor:toolbarTintColor];
}

/**
 *  Set Action Tool Bar Button Color
 *
 *  @param buttonColor Custom color for toolBar button
 */
- (void)setToolbarButtonColor:(UIColor *)toolbarButtonColor
{
    _toolbarButtonColor = toolbarButtonColor;
    [self.actionToolbar setTintColor:toolbarButtonColor];
}

/*!
 Font for the UIPickerView
 */
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.actionToolbar.titleButton.font = titleFont;
}

/*!
 *  Color for the UIPickerView
 */
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.actionToolbar.titleButton.titleColor = titleColor;
}

#pragma mark - Done/Cancel
- (void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerViewWillCancel:)]) {
        [self.delegate actionSheetPickerViewWillCancel:self];
    }
    __weak typeof(&*self) weakSelf = self;
    [self dismissWithCompletion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(actionSheetPickerViewDidCancel:)]) {
            [weakSelf.delegate actionSheetPickerViewDidCancel:weakSelf];
        }
    }];
}

- (void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    switch (_actionSheetPickerStyle) {
        case IQActionSheetPickerStyleTextPicker:
        {
            NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
            for (NSInteger component = 0; component < self.pickerView.numberOfComponents; component++) {
                NSInteger row = [self.pickerView selectedRowInComponent:component];
                if (row!= -1) {
                    [selectedTitles addObject:_titlesForComponents[component][row]];
                } else {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
            [self setSelectedTitles:selectedTitles];
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectTitles:)]) {
                [self.delegate actionSheetPickerView:self didSelectTitles:selectedTitles];
            }
        }
            break;
        case IQActionSheetPickerStyleDatePicker:
        case IQActionSheetPickerStyleDateTimePicker:
        case IQActionSheetPickerStyleTimePicker:
        {
            [self setDate:self.datePicker.date];
            [self setSelectedTitles:@[self.datePicker.date]];
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectDate:)]) {
                [self.delegate actionSheetPickerView:self didSelectDate:self.datePicker.date];
            }
        }
            break;
    }
    [self dismiss];
}

#pragma mark - IQActionSheetPickerStyleDatePicker / IQActionSheetPickerStyleDateTimePicker / IQActionSheetPickerStyleTimePicker

- (void)dateChanged:(UIDatePicker*)datePicker
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    _date = date;
    if (_date != nil) {
        [self.datePicker setDate:date animated:animated];
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

#pragma mark - IQActionSheetPickerStyleTextPicker

- (void)reloadComponent:(NSInteger)component
{
    [self.pickerView reloadComponent:component];
}

- (void)reloadAllComponents
{
    [self.pickerView reloadAllComponents];
}

- (void)setSelectedTitles:(NSArray *)selectedTitles
{
    [self setSelectedTitles:selectedTitles animated:NO];
}

- (NSArray *)selectedTitles
{
    if (_actionSheetPickerStyle == IQActionSheetPickerStyleTextPicker) {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
        NSUInteger totalComponent = self.pickerView.numberOfComponents;
        for (NSInteger component = 0; component < totalComponent; component++) {
            NSInteger selectedRow = [self.pickerView selectedRowInComponent:component];
            if (selectedRow == -1) {
                [selectedTitles addObject:[NSNull null]];
            } else {
                NSArray *items = _titlesForComponents[component];
                if ([items count] > selectedRow) {
                    id selectTitle = items[selectedRow];
                    [selectedTitles addObject:selectTitle];
                } else {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
        }
        return selectedTitles;
    } else {
        return nil;
    }
}

- (void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated
{
    if (_actionSheetPickerStyle == IQActionSheetPickerStyleTextPicker) {
        NSUInteger totalComponent = MIN(selectedTitles.count, self.pickerView.numberOfComponents);
        for (NSInteger component = 0; component < totalComponent; component++) {
            NSArray *items = _titlesForComponents[component];
            id selectTitle = selectedTitles[component];
            if ([items containsObject:selectTitle]) {
                NSUInteger rowIndex = [items indexOfObject:selectTitle];
                [self.pickerView selectRow:rowIndex inComponent:component animated:animated];
            }
        }
    }
}

- (void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    if (_actionSheetPickerStyle == IQActionSheetPickerStyleTextPicker) {
        NSUInteger totalComponent = MIN(indexes.count, self.pickerView.numberOfComponents);
        for (NSInteger component = 0; component < totalComponent; component++) {
            NSArray *items = _titlesForComponents[component];
            NSUInteger selectIndex = [indexes[component] unsignedIntegerValue];
            if (selectIndex < items.count) {
                [self.pickerView selectRow:selectIndex inComponent:component animated:animated];
            }
        }
    }
}

#pragma mark - UIPickerView delegate/dataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //If having widths
    if (_widthsForComponents) {
        //If object isKind of NSNumber class
        if ([_widthsForComponents[component] isKindOfClass:[NSNumber class]]) {
            CGFloat width = [_widthsForComponents[component] floatValue];
            if (width == 0) {
                //If width is 0, then calculating it's size.
                return ((pickerView.bounds.size.width - 20) - 2 * (_titlesForComponents.count - 1))/_titlesForComponents.count;
            } else {
                //Else returning it's width.
                return width;
            }
        } else {
            //Else calculating it's size.
            return ((pickerView.bounds.size.width - 20) - 2 * (_titlesForComponents.count - 1))/_titlesForComponents.count;
        }
    } else {
        //Else calculating it's size.
        return ((pickerView.bounds.size.width - 20) - 2 * (_titlesForComponents.count - 1))/_titlesForComponents.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponents count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_titlesForComponents[component] count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    if (self.pickerComponentsColor != nil) {
        labelText.textColor = self.pickerComponentsColor;
    }
    if (self.pickerComponentsFont == nil){
        labelText.font = [UIFont boldSystemFontOfSize:20.0];
    } else {
        labelText.font = self.pickerComponentsFont;
    }
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:_titlesForComponents[component][row]];
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isRangePickerView && pickerView.numberOfComponents == 3) {
        if (component == 0) {
            [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
        } else if (component == 2) {
            [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didChangeRow:inComponent:)]) {
        [self.delegate actionSheetPickerView:self didChangeRow:row inComponent:component];
    }
}

#pragma mark - show/Hide
- (void)dismiss
{
    [self.actionSheetController dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion
{
    [self.actionSheetController dismissWithCompletion:completion];
}

- (void)show
{
    [self showWithCompletion:nil];
}

- (void)showWithCompletion:(void (^)(void))completion
{
    [self.pickerView reloadAllComponents];
    self.actionSheetController = [[IQActionSheetViewController alloc] init];
    [self.actionSheetController showPickerView:self completion:completion];
}

#pragma mark set&get
- (IQActionSheetToolbar *)actionToolbar
{
    if (!_actionToolbar) {
        _actionToolbar = [[IQActionSheetToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _actionToolbar.barStyle = UIBarStyleDefault;
        _actionToolbar.cancelButton.target = self;
        _actionToolbar.cancelButton.action = @selector(pickerCancelClicked:);
        _actionToolbar.doneButton.target = self;
        _actionToolbar.doneButton.action = @selector(pickerDoneClicked:);
    }
    return _actionToolbar;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.actionToolbar.frame) , CGRectGetWidth(self.actionToolbar.frame), 216)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView setShowsSelectionIndicator:YES];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:self.pickerView.frame];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    return _datePicker;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllViews];
}

- (void)removeAllViews
{
    [_pickerView removeFromSuperview];
    [_datePicker removeFromSuperview];
    [_actionToolbar removeFromSuperview];
    _pickerView.delegate = nil;
    _actionToolbar.delegate = nil;
    _pickerView = nil;
    _datePicker = nil;
    _actionToolbar = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self removeFromSuperview];
}

@end

