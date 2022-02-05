#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS build
WORKDIR /src
COPY ["GitDemoCIGithub.csproj", "."]
RUN dotnet restore "./GitDemoCIGithub.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "GitDemoCIGithub.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GitDemoCIGithub.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GitDemoCIGithub.dll"]