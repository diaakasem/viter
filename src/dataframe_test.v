module dataframe_test

import math
import dataframe

struct GPair {
    g f64
    i f64
}

fn find_val(z []GPair, key f64) f64 {
    for entry in z {
        if entry.g == key {
            return entry.i
        }
    }
    return -999.0
}

fn testsuite_begin() {
    println("Starting DataFrame tests...")
}

fn testsuite_end() {
    println("DataFrame tests finished.")
}

fn test_create_dataframe() {
    data := {
        "col1": [1.0, 2.0, 3.0],
        "col2": [4.0, 5.0, 6.0],
    }
    df := dataframe.create_dataframe(data) or {
        assert false, "Failed to create DataFrame: $err"
        return
    }
    assert df.len() == 3
    assert df.columns_list().len == 2
    val := df.get(1, "col1") or { -999.0 }
    assert val == 2.0
}

fn test_select_columns() {
    data := {
        "a": [10.0, 20.0, 30.0],
        "b": [5.0,  6.0,  7.0],
        "c": [2.0,  2.0,  2.0],
    }
    df := dataframe.create_dataframe(data) or {
        assert false, "Failed to create DataFrame: $err"
        return
    }
    df_sub := df.select_columns(["a", "c"]) or {
        assert false, "Failed to select columns: $err"
        return
    }
    assert df_sub.columns_list() == ["a", "c"]
    assert df_sub.len() == 3
    a_val := df_sub.get(0, "a") or { -999.0 }
    c_val := df_sub.get(2, "c") or { -999.0 }
    assert a_val == 10.0
    assert c_val == 2.0
}

fn test_filter_rows() {
    data := {
        "x": [1.0, 2.0, 3.0, 4.0],
        "y": [10.0,20.0,30.0,40.0],
    }
    df := dataframe.create_dataframe(data) or {
        assert false, "Failed to create DataFrame: $err"
        return
    }
    df_filtered := df.filter_rows(fn [df](i int) bool {
        return df.columns["x"][i] > 2.0
    })
    assert df_filtered.len() == 2
    val_x := df_filtered.get(0, "x") or { -999.0 }
    val_y := df_filtered.get(1, "y") or { -999.0 }
    assert val_x == 3.0
    assert val_y == 40.0
}

fn test_map_column() {
    data := {
        "score": [10.0, 20.0, 30.0],
    }
    df := dataframe.create_dataframe(data) or {
        assert false, "Failed to create DataFrame: $err"
        return
    }
    df_mapped := df.map_column("score", fn (v f64) f64 {
        return v * 2.0
    }) or {
        assert false, "Map column failed: $err"
        return
    }
    assert df_mapped.len() == 3
    val0 := df_mapped.get(0, "score") or { -999.0 }
    val2 := df_mapped.get(2, "score") or { -999.0 }
    assert val0 == 20.0
    assert val2 == 60.0
}

fn test_add_column() {
    data := {
        "x": [2.0, 4.0, 6.0],
    }
    df := dataframe.create_dataframe(data) or {
        assert false, "Failed to create DataFrame: $err"
        return
    }
    df_new := df.add_column("x_squared", fn (i int, d dataframe.DataFrame) f64 {
        val := d.columns["x"][i]
        return val * val
    }) or {
        assert false, "Failed to add column: $err"
        return
    }

    val0 := df_new.get(0, "x_squared") or { -999.0 }
    val2 := df_new.get(2, "x_squared") or { -999.0 }

    assert df_new.columns_list().len == 2
    assert val0 == 4.0
    assert val2 == 36.0
}

fn test_group_by_and_aggregate() {
    data := {
        "age":    [23.0, 44.0, 33.0, 44.0, 44.0],
        "income": [50000.0, 60000.0, 70000.0, 50000.0, 100000.0],
    }
    df := dataframe.create_dataframe(data) or {
        assert false, "Failed to create DataFrame: $err"
        return
    }
    groups := df.group_by("age") or {
        assert false, "Group by failed: $err"
        return
    }

    df_agg := dataframe.aggregate(groups, dataframe.mean_col)
    // Sort by group column for consistent checks
    group_col := df_agg.columns["group"]
    income_col := df_agg.columns["income"]

    mut zipped := []GPair{}
    for i, gval in group_col {
        zipped << GPair{ g: gval, i: income_col[i]}
    }

    // Check expected means
    // For 44.0: (60000 + 50000 + 100000) / 3 = 70000
    assert math.abs(find_val(zipped, 23.0) - 50000.0) < 0.0001
    assert math.abs(find_val(zipped, 33.0) - 70000.0) < 0.0001
    assert math.abs(find_val(zipped, 44.0) - 70000.0) < 0.0001
}
