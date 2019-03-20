# Image usage only for build process
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 as build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./src ./
RUN dotnet restore ./Kubeless.WebAPI/

# Copy everything else and build in release mode
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/src/Kubeless.WebAPI/out .
ENTRYPOINT ["dotnet", "Kubeless.WebAPI.dll"]
