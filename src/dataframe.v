module dataframe

import math

pub struct DataFrame {
pub mut:
    columns map[string][]f64
}

// create_dataframe creates a new DataFrame from a map of column names to numeric arrays.
// All arrays must be of the same length or it will return an error.
pub fn create_dataframe(cols map[string][]f64) !DataFrame {
    if cols.len == 0 {
        return error("Cannot create an empty DataFrame.")
    }
    // Check length consistency
    first_col := cols.keys()[0]
    length := cols[first_col].len
    for col_name in cols.keys() {
        if cols[col_name].len != length {
            return error("All columns must have the same length.")
        }
    }
    return DataFrame{
        columns: cols
    }
}

// len returns the number of rows in the DataFrame
pub fn (df &DataFrame) len() int {
    if df.columns.len == 0 {
        return 0
    }
    first_col := df.columns.keys()[0]
    return df.columns[first_col].len
}

// columns_list returns the list of column names.
pub fn (df &DataFrame) columns_list() []string {
    return df.columns.keys()
}

// get returns the data in a given cell: df.get(row, column_name).
pub fn (df &DataFrame) get(row int, col string) !f64 {
    if col !in df.columns {
        return error("No such column: $col")
    }
    if row < 0 || row >= df.len() {
        return error("Row index out of range.")
    }
    return df.columns[col][row]
}

// select_columns returns a new DataFrame with only the specified columns.
pub fn (df &DataFrame) select_columns(cols []string) !DataFrame {
    mut new_cols := map[string][]f64{}
    for c in cols {
        if c !in df.columns {
            return error("Column $c not found.")
        }
        new_cols[c] = df.columns[c]
    }
    return create_dataframe(new_cols)
}

// filter_rows returns a new DataFrame containing only rows for which predicate(row) returns true.
// predicate is a function that takes a row index and returns bool.
pub fn (df &DataFrame) filter_rows(predicate fn (int) bool) DataFrame {
    mut indices := []int{}
    for i in 0 .. df.len() {
        if predicate(i) {
            indices << i
        }
    }
    mut new_cols := map[string][]f64{}
    for col_name, col_data in df.columns {
        new_cols[col_name] = indices.map(col_data[it])
    }
    return DataFrame{
        columns: new_cols
    }
}

// map_column applies a function to each value in a column, returning a new DataFrame with that column transformed.
pub fn (df &DataFrame) map_column(col_name string, f fn (f64) f64) !DataFrame {
    if col_name !in df.columns {
        return error("Column $col_name not found.")
    }
    mut new_cols := df.columns.clone()
    new_cols[col_name] = new_cols[col_name].map(f(it))
    return create_dataframe(new_cols)
}

// add_column adds a new column computed from a function of the row index (and optionally using df.get).
pub fn (df &DataFrame) add_column(col_name string, f fn (int, DataFrame) f64) !DataFrame {
    if col_name in df.columns {
        return error("Column $col_name already exists.")
    }
    mut new_cols := df.columns.clone()
    mut new_data := []f64{len: df.len()}
    for i in 0 .. df.len() {
        new_data[i] = f(i, *df)
    }
    new_cols[col_name] = new_data
    return create_dataframe(new_cols)
}

// group_by groups rows by a certain column (categorical or discrete numeric) and returns a map from group key to DataFrame subset.
pub fn (df &DataFrame) group_by(col_name string) !map[f64]DataFrame {
    if col_name !in df.columns {
        return error("Column $col_name not found.")
    }
    mut groups := map[f64][]int{}
    col_data := df.columns[col_name]
    for i, val in col_data {
        if val !in groups {
            groups[val] = []int{}
        }
        groups[val] << i
    }

    mut out := map[f64]DataFrame{}
    for key, indices in groups {
        mut new_cols := map[string][]f64{}
        for c, data in df.columns {
            new_cols[c] = indices.map(data[it])
        }
        out[key] = DataFrame{
            columns: new_cols
        }
    }
    return out
}

// aggregate applies an aggregation function per column to a grouped DataFrame map, returning a new summary DataFrame.
// agg is a function that takes an array of values and returns a single value (e.g. sum, mean, etc.)
pub fn aggregate(groups map[f64]DataFrame, agg fn([]f64) f64) DataFrame {
    if groups.len == 0 {
        return DataFrame{}
    }
    // All groups should have same columns
    group_keys := groups.keys()
    first_df := groups[group_keys[0]]
    cols := first_df.columns_list()

    mut agg_data := map[string][]f64{}
    for c in cols {
        agg_data[c] = []
    }

    mut group_col := []f64{}
    for key in groups.keys() {
        group_col << key
        gdf := groups[key]
        for c in cols {
            agg_data[c] << agg(gdf.columns[c])
        }
    }
    agg_data["group"] = group_col

    return DataFrame{
        columns: agg_data
    }
}

// Example aggregator functions
pub fn sum_col(vals []f64) f64 {
    mut s := 0.0
    for v in vals {
        s += v
    }
    return s
}

pub fn mean_col(vals []f64) f64 {
    if vals.len == 0 {
        return f64(math.nan())
    }
    return sum_col(vals) / vals.len
}
//
// // Example usage:
// pub fn main() {
//     data := {
//         "age":    [23.0, 44.0, 33.0, 44.0, 44.0],
//         "income": [50000.0, 60000.0, 70000.0, 50000.0, 100000.0],
//     }
//
//     df := create_dataframe(data) or {
//         eprintln(err)
//         return
//     }
//     println("Original DataFrame:")
//     println(df)
//
//     // Select a subset of columns
//     df_subset := df.select_columns(["age"]) or { panic(err) }
//     println("Subset (age):")
//     println(df_subset)
//
//     // Filter rows where age > 30
//     df_filtered := df.filter_rows(fn (i int) bool {
//         return df.columns["age"][i] > 30
//     })
//     println("Filtered (age > 30):")
//     println(df_filtered)
//
//     // Map a column: add 10 to income
//     df_mapped := df.map_column("income", fn (x f64) f64 {
//         return x + 10
//     }) or { panic(err) }
//     println("Mapped (income + 10):")
//     println(df_mapped)
//
//     // Add a computed column: income_tax = income * 0.3
//     df_with_new_col := df.add_column("income_tax", fn (i int, df DataFrame) f64 {
//         val := df.columns["income"][i]
//         return val * 0.3
//     }) or { panic(err) }
//     println("With new column (income_tax):")
//     println(df_with_new_col)
//
//     // Group by age and aggregate income by mean
//     groups := df.group_by("age") or { panic(err) }
//     df_agg := aggregate(groups, mean_col)
//     println("Aggregated by age (mean):")
//     println(df_agg)
// }
