# Loaded automatically by Python at start-up (PYTHONPATH=/app).
# Remove botocore's "Expect: 100-continue" handler so S3 uploads to the bundled
# MinIO (reached through the template's public HTTPS gateway) don't stall.
try:
    import botocore.handlers as _h

    _h.BUILTIN_HANDLERS[:] = [x for x in _h.BUILTIN_HANDLERS if x[1] is not _h.add_expect_header]
except Exception:  # botocore missing or changed: keep default behaviour
    pass
