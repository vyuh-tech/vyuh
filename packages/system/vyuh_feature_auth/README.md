# Vyuh Feature Auth 🔐

Authentication feature for Vyuh applications, providing flexible and customizable authentication flows. This package includes various authentication methods like email/password, phone OTP, and OAuth, with content-driven UI components that can be customized through Sanity.io CMS.

## Features ✨

- **Multiple Auth Methods** 🔑: Support for email/password, phone OTP, and OAuth authentication
- **Content-driven Forms** 📝: Customizable authentication forms using Sanity.io CMS
- **Flexible Layouts** 🎨: Multiple layout options for different presentation styles
- **Action Integration** 🔄: Built-in actions for auth flows like sign in, sign up, and password reset
- **Error Handling** ⚠️: Comprehensive error handling and user feedback

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_feature_auth: any
```

## Usage 💡

### Feature Registration
Register the auth feature in your Vyuh application setup:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart' as auth;

void main() {
  vyuh.runApp(
    initialLocation: '/',
    plugins: _getPlugins(),
    features: () => [
      auth.feature,
      // ... other features
    ],
  );
}
```

### Content Examples 🎯

#### Email/Password Form 📧
```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart' as auth;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

// Create and render an email/password form
final form = auth.EmailPasswordForm(
  actionType: auth.AuthActionType.signIn,
  showPasswordVisibilityToggle: true,
  action: Action(
    title: 'Sign In',
    configurations: [
      system.NavigationAction(
        navigationType: system.NavigationType.replace,
        linkType: system.LinkType.url,
        url: '/dashboard',
      ),
    ],
  ),
  forgotPasswordAction: Action(
    title: 'Forgot Password',
    configurations: [
      system.NavigationAction(
        navigationType: system.NavigationType.push,
        linkType: system.LinkType.url,
        url: '/auth/forgot-password',
      ),
    ],
  ),
);

// Render in a widget
class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vyuh.content.buildContent(context, form),
    );
  }
}
```

#### Phone OTP Form 📱
```dart
// Create and render a phone OTP form
final form = auth.PhoneOtpForm(
  action: Action(
    title: 'Verify OTP',
    configurations: [
      AuthConfiguration(
        schemaType: 'auth.verifyOtp',
        redirectTo: '/dashboard',
      ),
      system.NavigationAction(
        navigationType: system.NavigationType.replace,
        linkType: system.LinkType.url,
        url: '/dashboard',
      ),
    ],
  ),
);

// Render in a widget
vyuh.content.buildContent(context, form);
```

#### OAuth Sign In 🔗
```dart
// Create and render OAuth sign in options
final oauth = auth.OAuthSignIn(
  providers: [
    Action(
      title: 'Sign in with Google',
      configurations: [
        AuthConfiguration(
          schemaType: 'auth.oauth',
          provider: 'google',
        ),
        system.NavigationAction(
          navigationType: system.NavigationType.replace,
          linkType: system.LinkType.url,
          url: '/dashboard',
        ),
      ],
    ),
    Action(
      title: 'Sign in with GitHub',
      configurations: [
        AuthConfiguration(
          schemaType: 'auth.oauth',
          provider: 'github',
        ),
        system.NavigationAction(
          navigationType: system.NavigationType.replace,
          linkType: system.LinkType.url,
          url: '/dashboard',
        ),
      ],
    ),
  ],
);

// Render in a widget
vyuh.content.buildContent(context, oauth);
```

#### Hint Action Text 💭
```dart
// Create and render a hint text with action
final hint = auth.HintActionText(
  text: 'Don\'t have an account?',
  action: Action(
    title: 'Sign up',
    configurations: [
      system.NavigationAction(
        navigationType: system.NavigationType.push,
        linkType: system.LinkType.url,
        url: '/auth/signup',
      ),
    ],
  ),
  actionText: 'Sign up',
);

// Render in a widget
vyuh.content.buildContent(context, hint);
```

## Content Types 📝

The auth feature provides the following content types:

- `auth.emailPasswordForm` 📧: Email and password authentication form
- `auth.phoneOtpForm` 📱: Phone number verification with OTP
- `auth.oauthSignIn` 🔗: Social authentication options
- `auth.forgotPasswordForm` 🔑: Password reset form
- `auth.hintActionText` 💭: Helper text with action link

Each content type comes with its own layout configuration and can be customized through Sanity.io CMS.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

## License 📄

This project is licensed under the terms specified in the LICENSE file.
