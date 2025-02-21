#
# PHASE: coverage
#
# DOCUMENT THIS
#

load(
    "@io_bazel_rules_scala//scala/private:coverage_replacements_provider.bzl",
    _coverage_replacements_provider = "coverage_replacements_provider",
)
load(
    "@io_bazel_rules_scala//scala/private:rule_impls.bzl",
    _allow_security_manager = "allow_security_manager",
)

def phase_coverage_library(ctx, p):
    args = struct(
        srcjars = p.collect_srcjars,
    )
    return _phase_coverage_default(ctx, p, args)

def phase_coverage_common(ctx, p):
    return _phase_coverage_default(ctx, p)

def _phase_coverage_default(ctx, p, _args = struct()):
    return _phase_coverage(
        ctx,
        p,
        _args.srcjars if hasattr(_args, "srcjars") else depset(),
    )

def _phase_coverage(ctx, p, srcjars):
    instrumented_files_provider = coverage_common.instrumented_files_info(
        ctx,
        source_attributes = ["srcs"],
        dependency_attributes = _coverage_replacements_provider.dependency_attributes,
        extensions = ["scala", "java"],
    )
    external_providers = {
        "InstrumentedFilesInfo": instrumented_files_provider,
    }

    return struct(
        replacements = {},
        external_providers = external_providers,
    )
