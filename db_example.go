db, err := sql.Open("mysql", "myTeam:password@localhost:3306/myDB")
	if err != nil {
		return nil, err
	}

	db.SetMaxIdleConns(maxIdleConns)
	db.SetMaxOpenConns(maxOpenConns)

	dbx := sqlx.NewDb(db, driver)

