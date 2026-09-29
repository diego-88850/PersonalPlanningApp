test "valid_name trims and bounds" {
    assert valid_name("meds");
    assert not valid_name("   ");
    assert not valid_name("x" * 81);
    assert valid_name("x" * 80);
}
