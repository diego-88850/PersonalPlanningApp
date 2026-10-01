test "valid_name trims and bounds" {
    assert valid_name("meds");
    assert not valid_name("   ");
    assert not valid_name("x" * 81);
    assert valid_name("x" * 80);
}

test "valid_text caps free text" {
    assert valid_text("");
    assert valid_text("x" * text_limit());
    assert not valid_text("x" * (text_limit() + 1));
}
