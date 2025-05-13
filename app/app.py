from flask import Flask
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

app = Flask(__name__)

VAULT_URL = "https://mikaKeyVault.vault.azure.net/"

credential = DefaultAzureCredential()
client = SecretClient(vault_url=VAULT_URL, credential=credential)

try:
    secret = client.get_secret("SuperSecret").value
except Exception as e:
    secret = f"Error retrieving secret: {str(e)}"


@app.route('/')
def hello():
    return "Hello, World!" 

@app.route('/sec')
def sec():
    return f"Hello from AKS! 🔐 Secret is: {secret}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
