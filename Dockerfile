# Stage 1: Base
ARG PLATFORM=amd64
FROM --platform=linux/${PLATFORM} python:3.11 as base

# Install Poetry
RUN pip install poetry --no-cache-dir

# Stage : Development
FROM base as development
# Set working directory
WORKDIR /app
# Copy Poetry configuration files
COPY pyproject.toml ./
# Install development dependencies
RUN poetry config virtualenvs.create false && poetry install

# Install duckdb CLI
RUN apt-get update && apt-get install -y jq unzip
RUN curl -L https://github.com/duckdb/duckdb/releases/download/v1.0.0/duckdb_cli-linux-amd64.zip > duckdb.zip
RUN unzip duckdb.zip -d /usr/local/bin
ENV PATH="/usr/local/bin:$PATH"

# Stage : Production
FROM base as production
# Set working directory
WORKDIR /app
# Copy Poetry configuration files
COPY Makefile pyproject.toml ./
# Install only runtime dependencies
RUN poetry install --no-dev --no-interaction --no-ansi

# Default command to keep container running for interactive `make` commands
CMD ["sleep", "infinity"]
