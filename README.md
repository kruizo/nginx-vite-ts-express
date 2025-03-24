# Nginx Vite TypeScript Express Template

![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Vite](https://img.shields.io/badge/vite-%2300C7B7.svg?style=for-the-badge&logo=vite&logoColor=white)
![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)
![Express](https://img.shields.io/badge/express-%23000000.svg?style=for-the-badge&logo=express&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white)

This template provides a starting point for building a web application using Nginx as a reverse proxy, Vite for frontend tooling, TypeScript for type-safe JavaScript, Express for the backend server, and Docker for containerization.

## Features

- **Hot Reload for Development**: Automatically reloads the frontend and server when code changes are detected.
- **Logging**: Integrated logging for both frontend and backend to monitor and debug applications.
- **Multi Environment Docker Configurations**: Separate configurations for development and production environments.
- **Makefile Commands**: Simplifies common tasks such as building and running Docker containers.
- **Faster Docker Builds**: Optimized Dockerfiles for quicker build times.

## Getting Started 🚀

### Prerequisites

- Node.js (v14 or higher)
- NPM or Yarn
- Docker (optional, for containerized deployment)

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/yourusername/nginx-vite-ts-express.git
   cd nginx-vite-ts-express
   ```

2. Install dependencies:
   ```sh
   cd frontend && npm install
   ```
   ```sh
   cd backend && npm install
   ```

### Development

1. Start vite by runnning the following command inside `/frontend` :

   ```sh
   npm run dev
   # or
   yarn dev
   ```

2. Start the express server by runnning the following command inside `/backend` :

   ```sh
   npm run dev
   # or
   yarn dev

   ```

3. Open your browser and navigate to `http://localhost:5173` to view your react application and `http://localhost:5000` to test your API.

## Docker 🐳

If you prefer docker for development or production with nginx, follow these steps for setting up docker.

### Development

1. Build the Docker images:

   ```sh
   docker compose build
   ```

   This command uses `docker-compose.override.yml` to build development images of `nginx`, `app`, and `server` with hot reload. You can change the image configuration inside `Dockerfile.dev`.

2. Run the images in containers.

   ```sh
   docker compose up
   ```

   **ALTERNATIVE:**,
   You can run `make build-dev` to build all dev images. Or `make up-dev` to start the dev images to containers. You can run `make help` to view all makefile commands.

### Production

1. Build the Docker images:

   ```sh
   docker-compose build -f docker-compose.yml
   ```

   This uses the default `docker-compose.yml` with production environemnt. Unlike dev, its `Dockerfile` builds the frontend which then served by nginx.

2. Run the production images in containers.
   ```sh
   docker compose -f docker-compose.yml up
   ```
   **ALTENATIVE:**,
   You can run `make build-prod` to build or `make up-prod` to start your production containers. You can run `make help` to view all makefile commands.

## Project Structure 📁

- `frontend/`: Source code for the frontend (Vite/TypeScript).
- `backend/`: Source code for the backend (Express).
- `nginx/`: Nginx configuration files.
- `Dockerfile`: Docker configuration for containerized production deployment.
- `Dockerfile.dev`: Docker configuration for containerized development.
- `docker-compose.yml`: Docker Compose configuration for production.
- `docker-compose.override.yml`: Docker Compose configuration for development.
- `Makefile`: Makefile commands for building and running Docker containers.

## Contributing 🤝

Contributions are welcome! Please open an issue or submit a pull request.

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
