
# APMIKIMMDO-SuperApps (WEB & APP)

## Run Locally

This project uses FVM for manage versions

[Read the FVM documentation](https://fvm.app)

flutter SDK Version : 2.0.6

Install dependencies

```sh
fvm flutter pub get
```

Start the server

```sh
# for mobile
fvm flutter run 
```

```sh
# for web
fvm flutter run -d <browser>
```


## Deployment

To deploy this project run

```sh
# for mobile (.apk)
fvm flutter build apk 
```

```sh
# for mobile (.apk) QA
fvm flutter build apk --dart-define ISQA=true
```

```sh
# for mobile (.aab)
fvm flutter build appbundle 
```

```sh
# for mobile (.aab | qa)
fvm flutter build appbundle --dart-define ISQA=true
```

```sh
# for web
fvm flutter build web 
```


## Environment Variables

To run this project, you will need to add the following environment variables to your `.<codename>.env` file

`BASE_URL`

## Generate Launcher Icons

To generate launcher icons in appropriate flavors, run the following command

```sh
fvm flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons*
```