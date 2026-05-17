// SPDX-License-Identifier: GPL-2.0
// Author: xunicatt
// Project: railm (railapi) 
// Copyright (c) 2026 xunicatt <contact.aniket.biswas@gmail.com>

package db

import "database/sql"

func resetStatusTable(sql *sql.DB) error {
	_, err := sql.Exec(`DELETE FROM status;`)
	return err;
}
