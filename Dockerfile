FROM mcr.microsoft.com/dotnet/core/sdk:6.0 AS build-env
WORKDIR /app

COPY . ./
RUN dotnet restore dotnetexample

COPY . ./
RUN dotnet publish dotnetexample/dotnetexample.csproj -c Release -o ../out

FROM mcr.microsoft.com/dotnet/core/runtime:6.0
WORKDIR /app
#build-env aliası veriyoruz yukarıda ordan çağırıyoruz: Orda oluşturulan dosyaları /app/out klasörünü kopyala demiş oluyoruz.
COPY --from=build-env /app/out .
#./simple_rabbitmq_eft.Consumer/Database.json dosyasını /app klasörünün içine kopyalar.
COPY ./dotnetexample/appsettings.json .
ENTRYPOINT ["dotnet" , "dotnetexample.dll"]