## Generating a New SSH Key
The SSH protocol enables one to authenticate to remote servers. SSH keys helps to connect to Github without having to supply a username or password everytime.
To generate a new SSH key, follow the below procedures:
>- Open your terminal and paste the below code
`ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
>- Specify a location to save the key
>- Enter a passphrase (Optional)
>- Hit the Enter key

Verify the key got generated at the above specified path
___