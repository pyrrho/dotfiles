@echo off

dotnet build C:\KCFTech\Prometheus\Prometheus.All.sln

dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.SharedTests && ^
dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.Restup.MvcTests && ^
dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.EntitiesTests && ^
dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.TimeSeriesDbDataProviderTests && ^
dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.DomainTests && ^
dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.MvcTests
REM dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.AWSLambda.Tests && ^
REM dotnet test --no-build C:\KCFTech\Prometheus\Prometheus.BurstDataProviderTests && ^

alert
