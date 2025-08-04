# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy solution and project files
COPY WebApplication2.sln ./
COPY WebApplication2.csproj ./

# Restore dependencies
RUN dotnet restore WebApplication2.csproj

# Copy the rest of the source code
COPY . ./

# Publish
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Create runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "WebApplication2.dll"]
