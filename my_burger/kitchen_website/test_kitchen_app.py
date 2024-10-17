from unittest.mock import patch, MagicMock
import pytest
from kitchen_website.kitchen_app import app

# Fixture to set up the test client
@pytest.fixture
def client():
    """
    Pytest fixture to set up the Flask test client.
    This client is used to simulate HTTP requests to the application during testing.
    
    Yields:
        FlaskClient: The test client for the Flask application.
    """
    with app.test_client() as client:
        yield client

@patch('kitchen_website.kitchen_app.get_db_connection')
def test_kitchen_page(mock_get_db_connection, client):
    """
    Test the kitchen page to ensure it returns the correct data.
    This test uses a mocked database connection to avoid actual database interactions.
    
    Args:
        mock_get_db_connection (MagicMock): Mocked function to replace get_db_connection.
        client (FlaskClient): The test client for the Flask application.
    """
    # Mock the connection and cursor to avoid connecting to the actual database
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_get_db_connection.return_value = mock_conn
    mock_conn.cursor.return_value = mock_cursor
    mock_cursor.fetchall.return_value = [
        (1, 'Lilla mohammed', 'Classic Burger', 'Add: Lettuce, Remove: Cheese')
    ]

    # Send a GET request to the root URL ('/')
    response = client.get('/')

    # Assert that the response status code is 200 (OK)
    assert response.status_code == 200
    # Assert that the response data contains the expected order information
    assert b"Lilla mohammed" in response.data
