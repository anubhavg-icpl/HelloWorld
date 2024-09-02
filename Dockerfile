# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /source
COPY *.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /app -r linux-musl-x64 --self-contained true /p:PublishTrimmed=true /p:PublishSingleFile=true /p:InvariantGlobalization=true

# Ensure the binary is executable
RUN chmod +x /app/HelloWorld

# Stage 2: Create the final image
FROM scratch

# Copy the published app
COPY --from=build /app/HelloWorld /HelloWorld

# Set the entrypoint
ENTRYPOINT ["/HelloWorld"]