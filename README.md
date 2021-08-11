# f-commerce
This is a simple dummy ecommerce app consisting of a few pages: Home, Product Detail, Cart Items, Confirmation, & Success Page.
This app consumes f-commerce API (my own firebase API) for fetching products and product details.

## Tech stacks:
- **flutter_bloc** for State Management
- **get_it** for Dependency Injection
- **http** for network requests
- **retry** for defining Retry Policies on network requests
- **rx_dart** for creating cached Broadcast Stream
- **intl** for date & price formatting
- **lint** for guiding Dart effective-style
- uses Repository Pattern for data abstraction and Singleton pattern for helper classes

### Notes:
The field "ndkVersion "22.1.7171670"" in the Android project build.gradle (app-level) 
is needed for me to run the app properly on VSCode, so if anything goes wrong when trying 
to run the project, you might need to edit it or remove it.

This app uses the latest Flutter (2.2.3) and Dart (2.13.4) version (as of July 31st 2021).
