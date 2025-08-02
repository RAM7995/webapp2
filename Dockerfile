# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY *.sln .
COPY WebApplication2/*.csproj ./WebApplication2/
RUN dotnet restore

# Copy the rest of the code
COPY WebApplication2/. ./WebApplication2/
WORKDIR /src/WebApplication2

# Build and publish the app
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Create runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# Copy the published app from build stage
COPY --from=build /app/publish .

# Expose port (default ASP.NET Core port)
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "WebApplication2.dll"]
