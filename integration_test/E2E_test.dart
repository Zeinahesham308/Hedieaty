import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedieaty/main.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for testing
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Hedieaty App E2E Test', () {
    testWidgets('Navigate to LoginScreen, login, and verify HomeScreen elements', (WidgetTester tester) async {
      // Step 1: Launch the app
      await tester.pumpWidget(const HedeieatyApp());
      await tester.pumpAndSettle(); // Wait for app animations to complete

      // Step 2: Tap the "Log in" button on the FirstScreen
      final Finder loginButton = find.byKey(const Key('login_button'));
      expect(loginButton, findsOneWidget, reason: 'Log in button should exist on FirstScreen');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(); // Wait for navigation to LoginScreen

      // Step 3: Verify the LoginScreen is displayed
      final Finder loginTitle = find.text('Log In');
      expect(loginTitle, findsOneWidget, reason: 'Log In title should be visible on LoginScreen');

      // Step 4: Enter email and password
      final Finder emailField = find.byKey(const Key('email_field'));
      final Finder passwordField = find.byKey(const Key('password_field'));
      final Finder loginActionButton = find.byKey(const Key('login_button'));

      expect(emailField, findsOneWidget, reason: 'Email field should exist on LoginScreen');
      expect(passwordField, findsOneWidget, reason: 'Password field should exist on LoginScreen');
      expect(loginActionButton, findsOneWidget, reason: 'Login button should exist on LoginScreen');

      await tester.enterText(emailField, 'MA@gmail.com');
      await tester.pumpAndSettle(); // Simulate user typing
      await tester.enterText(passwordField, '100zha100');
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(Duration(seconds: 5));
      // Step 5: Tap the login button
      await tester.tap(loginActionButton);
      await tester.pumpAndSettle(); // Wait for navigation or validation to finish

      await tester.pumpAndSettle(Duration(seconds: 5));
      // Step 6: Verify HomeScreen is displayed
      final Finder homeScreenTitle = find.byKey(const Key('welcome_message'));
      expect(homeScreenTitle, findsOneWidget, reason: 'Welcome message should be displayed on HomeScreen');


      // Step 7: Verify key elements on the HomeScreen
      final Finder createEventButton = find.byKey(const Key('create_event_button'));
      final Finder searchField = find.byKey(const Key('search_field'));
      final Finder friendsList = find.byKey(const Key('friends_list'));

      expect(createEventButton, findsOneWidget, reason: 'Create Event button should be present on HomeScreen');
      expect(searchField, findsOneWidget, reason: 'Search field should be present on HomeScreen');
      expect(friendsList, findsOneWidget, reason: 'Friends list should be present on HomeScreen');

      // Step 8: Interact with the Create Event button
      await tester.tap(createEventButton);
      await tester.pumpAndSettle(); // Wait for navigation to the event creation page
      await tester.pumpAndSettle(Duration(seconds: 3));
      // Step 9: Fill out and submit the event creation form
      final Finder eventNameField = find.byKey(const Key('event_name_field'));
      final Finder eventDateField = find.byKey(const Key('event_date_field'));
      final Finder eventLocationField = find.byKey(const Key('event_location_field'));
      final Finder eventDescriptionField = find.byKey(const Key('event_description_field'));
      final Finder createEventActionButton = find.byKey(const Key('create_event_action_button'));

      await tester.enterText(eventNameField, 'Test Event');
      await tester.pumpAndSettle();
      await tester.enterText(eventDateField, '2024-12-31');
      await tester.pumpAndSettle();
      await tester.enterText(eventLocationField, 'Test Location');
      await tester.pumpAndSettle();
      await tester.enterText(eventDescriptionField, 'This is a test event.');
      await tester.pumpAndSettle();

      await tester.tap(createEventActionButton);
      //await tester.pumpAndSettle(); // Wait for the event creation process to complete
      await tester.pumpAndSettle(Duration(seconds: 5));
      // Step 10: Return to the HomeScreen using the navigation bar



      final Finder nav_cal = find.byKey(const Key('nav_calendar'));
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(nav_cal);
      await tester.pumpAndSettle(); // Wait for navigation back to HomeScreen
      await tester.pumpAndSettle(Duration(seconds: 3));


      // Step 11: Interact with a friend item in the friends list
      final Finder nav_home = find.byKey(const Key('nav_home'));
      await tester.tap(nav_home);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 5));



      final Finder friendItem = find.byKey(const Key('friend_item_0'));
      expect(friendItem, findsOneWidget, reason: 'Friend item at index 1 should be present in the friends list');
      await tester.tap(friendItem);
      await tester.pumpAndSettle(); // Wait for navigation to the friend's event list
      await tester.pumpAndSettle(Duration(seconds: 5));


      final Finder friendfirstEvent = find.byKey(const Key('friend_event_container_0'));
      await tester.tap(friendfirstEvent);
      await tester.pumpAndSettle(); // Wait for navigation to the friend's event list
      await tester.pumpAndSettle(Duration(seconds: 5));


      // Step 12: Interact with the Pledge button
      final Finder pledgeButton = find.byKey(const Key('pledge_button_79782904-bc2f-4bd1-8b5b-bf9b0b05ed20'));
      expect(pledgeButton, findsOneWidget, reason: 'purchase button should be displayed');
      await tester.tap(pledgeButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Step 15: Navigate back twice
      await tester.pageBack(); // First back navigation
      await tester.pumpAndSettle(Duration(seconds: 7)); // Wait for navigation to settle

      await tester.pageBack(); // Second back navigation
      await tester.pumpAndSettle(Duration(seconds: 7)); // Wait for navigation to settle

      // Step 16: Verify that we returned to the HomeScreen
      final Finder homeScreenTitle2 = find.byKey(const Key('welcome_message'));
      expect(homeScreenTitle2, findsOneWidget, reason: 'Home screen should be displayed after navigating back twice');

      // Step 13: Navigate to the "My Pledged Gifts" page using navigation bar
      final Finder navGiftCard = find.byKey(const Key('nav_giftcard'));
      expect(navGiftCard, findsOneWidget, reason: 'GiftCard navigation should exist');
      await tester.tap(navGiftCard);
      await tester.pumpAndSettle(Duration(seconds: 5));


      final Finder ProfileItem = find.byKey(const Key('nav_profile'));
      await tester.tap(ProfileItem);
      await tester.pumpAndSettle(); // Wait for navigation to the friend's event list
      await tester.pumpAndSettle(Duration(seconds: 5));



    });
  });
}