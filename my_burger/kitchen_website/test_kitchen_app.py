from unittest.mock import patch, MagicMock
import pytest
from kitchen_website.kitchen_app import app

# Fixture to set up the test client
@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

# Test the kitchen page with mocked database connection
@patch('kitchen_website.kitchen_app.get_db_connection')
def test_kitchen_page(mock_get_db_connection, client):
    # Mock the connection and cursor to avoid connecting to the actual database
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_get_db_connection.return_value = mock_conn
    mock_conn.cursor.return_value = mock_cursor
    mock_cursor.fetchall.return_value = [
        (1, 'Lilla mohammed', 'Classic Burger', 'Add: Lettuce, Remove: Cheese')
    ]
    
    response = client.get('/')
    
    assert response.status_code == 200
    assert b"John Doe" in response.data
    assert b"Classic Burger" in response.data
