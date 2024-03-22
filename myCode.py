import requests
import json
import boto3
from datetime import datetime

def download_data(url):
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to download data from {url}. Status code: {response.status_code}")
        return None

def extract_specific_data(data):
    # Example extraction for Coinbase API data
    specific_data = data.get('data', {}).get('rates', {})
    czk_data = {'CZK': specific_data.get('CZK')} if specific_data.get('CZK') else {}
    return czk_data

def generate_html_table(data):
    html_content = "<html><head><title>Extracted Data for Prague</title></head><body><table border='1'>"
    html_content += "<tr><th>Currency</th><th>Rate</th></tr>"
    for currency, rate in data.items():
        html_content += f"<tr><td>{currency}</td><td>{rate}</td></tr>"
    html_content += "</table></body></html>"
    return html_content

def upload_to_s3(html_content, bucket_name, object_name):
    s3 = boto3.client('s3')
    try:
        response = s3.put_object(Bucket=bucket_name, Key=object_name, Body=html_content, ContentType='text/html')
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print(f"HTML page uploaded to S3://{bucket_name}/{object_name} successfully!")
        else:
            print(f"Failed to upload HTML page to S3. Response: {response}")
    except Exception as e:
        print(f"Failed to upload HTML page to S3: {e}")


if __name__ == "__main__":
    # Download data from Coinbase API
    coinbase_data = download_data("https://api.coinbase.com/v2/exchange-rates")
    
    if coinbase_data:
        # Upload data page to S3
        bucket_name = "azul_dataextractor"  # Replace with your S3 bucket name
        object_name = f"index_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        upload_to_s3(json.dumps(coinbase_data), bucket_name, object_name)

        # Extract specific data
        specific_data = extract_specific_data(coinbase_data)

        # Generate HTML table
        html_content = generate_html_table(specific_data)

        # Upload HTML page to S3
        bucket_name = "azul_output"  # Replace with your S3 bucket name
        object_name = f"data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.html"
        upload_to_s3(html_content, bucket_name, object_name)
