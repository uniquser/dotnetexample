FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

COPY . ./
RUN dotnet restore MCGrunt.Consumer

COPY . ./
RUN dotnet publish MCGrunt.Consumer/MCGrunt.Consumer.Consumer.csproj -c Release -o ../out

FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
#build-env aliası veriyoruz yukarıda ordan çağırıyoruz: Orda oluşturulan dosyaları /app/out klasörünü kopyala demiş oluyoruz.
COPY --from=build-env /app/out .
#./simple_rabbitmq_eft.Consumer/Database.json dosyasını /app klasörünün içine kopyalar.
COPY ./MCGrunt.Consumer/appsettings.json .
ENTRYPOINT ["dotnet" , "MCGrunt.Consumer.dll"]