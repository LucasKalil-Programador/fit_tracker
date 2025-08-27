  const exerciseSQL = '''
          CREATE TABLE exercise(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            sets INTEGER NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('cardio', 'musclework'))
          );
        ''';

  const trainingPlanSQL = '''
          CREATE TABLE training_plan(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            list TEXT NOT NULL
          );
        ''';

  const trainingHistorySQL = '''
          CREATE TABLE training_history(
            uuid TEXT PRIMARY KEY,
            training_name TEXT NOT NULL,
            exercises TEXT NOT NULL,
            date_time INTEGER NOT NULL
          );
        ''';

  const metadataSQL = '''
          CREATE TABLE metadata(
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          );
        ''';
  
  const reportTableSQL = '''
          CREATE TABLE report_table(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            value_suffix TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          );
        ''';
  
  const reportSQL = '''
          CREATE TABLE report(
            uuid TEXT PRIMARY KEY,
            note TEXT NOT NULL,
            report_date INTEGER NOT NULL,
            value REAL NOT NULL,
            report_table_uuid TEXT NOT NULL
          );
        ''';