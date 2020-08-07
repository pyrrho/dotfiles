@echo off
echo.

echo dotnet build C:\KCFTech\Prometheus\Prometheus.All.sln
echo.
echo dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.SharedTests && ^
echo dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.Restup.MvcTests && ^
echo dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.EntitiesTests && ^
echo dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.TimeSeriesDbDataProviderTests && ^
echo dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.DomainTests && ^
echo dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.MvcTests
REM dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.AWSLambda.Tests && ^
REM dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.BurstDataProviderTests && ^
echo.
echo alert
