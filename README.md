# Restaurant Management Application

This Rails application provides a complete solution for restaurant management, including order tracking, customer management, and table reservations.

## Features

- **Staff Authentication**: Secure login with Multi-Factor Authentication
- **Order Management**: Track orders from pending to delivered
- **Customer Management**: Import and manage customer data
- **Reservation System**: Book and manage table reservations. *Note: The seed data for reservations creates reservations for dates 1 to 14 days in the future.
- **API Endpoints**: Allow customers to place orders and make reservations

## Setup Instructions

1. Clone the repository:
```
git clone https://github.com/robbieardison/rails-restaurant.git
cd restaurant-app
```
2. Install dependencies:
```
bundle install
```
3. Set up the database:
```
rails db:create db:migrate db:seed
```
4. Start the server:
```
rails server
```
5. Start Sidekiq (in a separate terminal):
```
bundle exec sidekiq
```

## Default Login

- Email: admin@restaurant.com
- Password: password123

## API Documentation

### Customers API

#### Create an Order

* **Endpoint:** `POST /api/v1/orders`
* **Headers:**
    * `X-API-Key: <customer_api_key>` (The API key of the customer placing the order)
* **Body (JSON):**

    ```json
    {
      "order": {
        "notes": "Extra napkins please"
      },
      "order_items": [
        {
          "menu_item_id": 1,
          "quantity": 2
        },
        {
          "menu_item_id": 3,
          "quantity": 1
        }
      ]
    }
    ```

    * `order`: Contains general order information.
        * `notes`:  Any special requests or instructions.
    * `order_items`: An array of items in the order.
        * `menu_item_id`:  The ID of the menu item (refer to the `menu_items` table).
        * `quantity`: The number of units of that menu item.

#### Create a Reservation

* **Endpoint:** `POST /api/v1/reservations`
* **Headers:**
    * `X-API-Key: <customer_api_key>` (The API key of the customer making the reservation)
* **Body (JSON):**

    ```json
    {
      "reservation": {
        "table_number": 5,
        "reserved_at": "2023-06-01T19:00:00"
      }
    }
    ```

    * `reservation`: Contains reservation details.
        * `table_number`: The table number to reserve.
        * `reserved_at`: The date and time for the reservation in ISO 8601 format (e.g., "YYYY-MM-DDTHH:MM:SS").

## Testing

Run the test suite:
```
rails test
```