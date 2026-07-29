const lithicaVersion = String.fromEnvironment(
  'LITHICA_VERSION',
  defaultValue: '1.0.0',
);

const lithicaBuildNumber = String.fromEnvironment(
  'LITHICA_BUILD',
  defaultValue: '1',
);

const lithicaVersionLabel = 'v$lithicaVersion+$lithicaBuildNumber';
