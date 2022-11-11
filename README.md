# CM_APP

## How to run the API

Install dependencies
```pip install -r requirements.txt```

Start API
```python3 -m uvicorn main:app --reload --host <ip_address>```

## Before running the application
Change ip_address in the url String on the \CM_APP\oart\lib\storage_services\api_service.dart file on line 7, to the same ip address as the API.