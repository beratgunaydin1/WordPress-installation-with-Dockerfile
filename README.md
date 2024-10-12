Today, I will show you how to set up WordPress using a Dockerfile. First, we need to install Docker Engine on our Linux machine. Please refer to the documentation at [this link](https://docs.docker.com/engine/install/ubuntu/) to perform the installation.

First, clone the repository to your machine using the command
`git clone https://github.com/beratgunaydin1/WordPress-installation-with-Dockerfile.git.`

Now that we have pulled the GitHub repository, we can edit our `nginx.conf` file. Let's open the `nginx.conf` file using the `vi` command.
In the `nginx.conf` file, replace the "localhost" in the `server_name localhost` line with your own domain. NOTE: I use Cloudflare for my domain, which automatically provides SSL/TLS support. If your domain hosting company does not offer SSL/TLS support, you will need to create your own SSL/TLS and add it in the `nginx.conf` file using port `443`.
NOTE: If you are not using a domain, leave it as `server_name localhost`.
Now that we have edited the Nginx configuration file, we can move on to MySQL.

Instead of using a Dockerfile, we pull the MySQL image directly and run it with the docker run
`docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpressuser -e MYSQL_PASSWORD=password -d mysql:5.7`
Explanation of the command I wrote above:
`--name mysql-container` Assigns the name "mysql-container" to the created container.
`-e MYSQL_ROOT_PASSWORD=rootpassword` This is an environment variable used to set a password for the "root" user of the MySQL database. In this example, the password is set to "rootpassword".
`-e MYSQL_DATABASE=wordpress` This specifies the name of a database that will be automatically created when the container is started. In this case, a database named "wordpress" will be created.
`-e MYSQL_USER=wordpressuser` This specifies a new username that will be created in MySQL. In this example, the username is set to "wordpressuser".
`-e MYSQL_PASSWORD=password` This is the password for the "wordpressuser" mentioned above. In this example, the password is set to "password".
`-d` This allows the container to run in detached mode, meaning it operates independently of the terminal.
`mysql:5.7` This specifies the MySQL image to be used. In this case, the MySQL image of version 5.7 will be used.

After this command, we have created a container from the mysql:5.7 image. We are now ready to run the Dockerfile.
First, we need to build the Dockerfile. To do this, let's run the command `docker build -t wordpress .`. NOTE: Remember that you need to be in the directory where the Dockerfile is located to run this command.

Now that the build process is complete, we can create the container.
To create the container, we should use the command docker `run -d --name wordpress-container --link mysql-container:mysql -p 80:80 wordpress`.
Explanation of the command I wrote above:
`--link mysql-container:mysql` This provides a link to the existing MySQL container named mysql-container. This allows the WordPress application to access the MySQL database using the name "mysql." This link automatically updates the IP address of the MySQL container for access.
`-p 80:80` This forwards port 80 of the container to port 80 of the host machine.
`wordpress` This is the name of the Docker image to be used. Here, the image name from the Dockerfile we built will be used.
You can now enter `https://Domain_name` in your browser to access the WordPress installation screen.
Thank you for reading my document.
