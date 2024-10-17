import pytest
from order_website.order_app import app


@pytest.fixture
def client():
    """
    Pytest fixture to set up the Flask test client.
    This client is used to simulate HTTP requests to the application during testing.
    
    Yields:
        FlaskClient: The test client for the Flask application.
    """
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_homepage(client):
    """
    Test the homepage response to ensure it returns a status code of 200 and contains the expected content.
    
    Args:
        client (FlaskClient): The test client for the Flask application.
    """
    response = client.get('/')
    assert response.status_code == 200
    assert b"Order a Burger" in response.data
