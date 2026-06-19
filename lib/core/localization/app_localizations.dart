import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('id', 'ID'), // Indonesian
    Locale('es', 'ES'), // Spanish
    Locale('fr', 'FR'), // French
    Locale('de', 'DE'), // German
    Locale('ja', 'JP'), // Japanese
    Locale('ko', 'KR'), // Korean
    Locale('zh', 'CN'), // Chinese
  ];

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Shorthand method
  String t(String key) => translate(key);

  // Common translations with getters for convenience
  String get appName => translate('app_name');
  String get home => translate('home');
  String get learn => translate('learn');
  String get orders => translate('orders');
  String get profile => translate('profile');
  String get cart => translate('cart');
  String get checkout => translate('checkout');
  String get search => translate('search');
  String get categories => translate('categories');
  String get products => translate('products');
  String get farmers => translate('farmers');
  String get settings => translate('settings');
  String get logout => translate('logout');
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get resetPassword => translate('reset_password');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get add => translate('add');
  String get remove => translate('remove');
  String get update => translate('update');
  String get submit => translate('submit');
  String get confirm => translate('confirm');
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');
  String get error => translate('error');
  String get success => translate('success');
  String get loading => translate('loading');
  String get noDataFound => translate('no_data_found');
  String get tryAgain => translate('try_again');
  String get language => translate('language');
  String get selectLanguage => translate('select_language');

  // Profile screen
  String get editProfile => translate('edit_profile');
  String get harvestPremium => translate('harvest_premium');
  String get premiumDescription => translate('premium_description');
  String get accountSettings => translate('account_settings');
  String get personalInformation => translate('personal_information');
  String get myAddresses => translate('my_addresses');
  String get notifications => translate('notifications');
  String get security => translate('security');
  String get support => translate('support');
  String get helpCenter => translate('help_center');
  String get privacyPolicy => translate('privacy_policy');
  String get aboutUs => translate('about_us');
  String get logoutConfirm => translate('logout_confirm');
  String get version => translate('version');

  // Shopping & Cart
  String get searchFreshProducts => translate('search_fresh_products');
  String get shopByCategory => translate('shop_by_category');
  String get freshToday => translate('fresh_today');
  String get seeAll => translate('see_all');
  String get farmersNearYou => translate('farmers_near_you');
  String get viewMap => translate('view_map');
  String get myCart => translate('my_cart');
  String get cartEmpty => translate('cart_empty');
  String get cartEmptyMessage => translate('cart_empty_message');
  String get startShopping => translate('start_shopping');
  String get clearCart => translate('clear_cart');
  String get subtotal => translate('subtotal');
  String get deliveryFee => translate('delivery_fee');
  String get total => translate('total');
  String get proceedToCheckout => translate('proceed_to_checkout');

  // Checkout & Orders
  String get checkoutTitle => translate('checkout_title');
  String get yourItems => translate('your_items');
  String get deliveryMethod => translate('delivery_method');
  String get paymentMethod => translate('payment_method');
  String get deliveryNotes => translate('delivery_notes');
  String get orderSummary => translate('order_summary');
  String get placeOrder => translate('place_order');
  String get homeDelivery => translate('home_delivery');
  String get pickup => translate('pickup');
  String get bankTransfer => translate('bank_transfer');
  String get ewallet => translate('ewallet');
  String get orderPlaced => translate('order_placed');
  String get orderSuccessMessage => translate('order_success_message');
  String get viewOrderDetails => translate('view_order_details');
  String get continueShopping => translate('continue_shopping');
  String get viewAllOrders => translate('view_all_orders');
  String get myOrders => translate('my_orders');
  String get all => translate('all');
  String get processing => translate('processing');
  String get delivered => translate('delivered');
  String get cancelled => translate('cancelled');
  String get noOrdersYet => translate('no_orders_yet');
  String get ordersEmptyMessage => translate('orders_empty_message');
  String get noOrdersCategory => translate('no_orders_category');
  String get orderNumber => translate('order_number');
  String get orderStatus => translate('order_status');
  String get orderTotal => translate('order_total');
  String get orderDetails => translate('order_details');
  String get sellerInformation => translate('seller_information');
  String get orderItems => translate('order_items');
  String get deliveryDetails => translate('delivery_details');
  String get paymentSummary => translate('payment_summary');
  String get cancelOrder => translate('cancel_order');
  String get cancelOrderConfirm => translate('cancel_order_confirm');
  String get orderCancelled => translate('order_cancelled');

  // Categories
  String get vegetables => translate('vegetables');
  String get fruits => translate('fruits');
  String get meat => translate('meat');
  String get fish => translate('fish');
  String get dairy => translate('dairy');
  String get eggs => translate('eggs');
  String get grains => translate('grains');
  String get herbs => translate('herbs');
  String get nuts => translate('nuts');
  String get honey => translate('honey');
  String get more => translate('more');
  String get allCategories => translate('all_categories');

  // Products
  String get addToCart => translate('add_to_cart');
  String get buyNow => translate('buy_now');
  String get share => translate('share');
  String get favorite => translate('favorite');
  String get productDetails => translate('product_details');
  String get description => translate('description');
  String get specifications => translate('specifications');
  String get deliveryOptions => translate('delivery_options');
  String get sellerInfo => translate('seller_info');
  String get reviews => translate('reviews');
  String get relatedProducts => translate('related_products');

  // Filters & Sorting
  String get sortBy => translate('sort_by');
  String get filter => translate('filter');
  String get popular => translate('popular');
  String get priceLowHigh => translate('price_low_high');
  String get priceHighLow => translate('price_high_low');
  String get nameAZ => translate('name_a_z');
  String get rating => translate('rating');
  String get organicOnly => translate('organic_only');
  String get premiumOnly => translate('premium_only');
  String get applyFilters => translate('apply_filters');
  String get clearFilters => translate('clear_filters');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
