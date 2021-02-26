<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#get_lint_config"></a>

## get_lint_config

<pre>
get_lint_config(<a href="#get_lint_config-linter_name">linter_name</a>, <a href="#get_lint_config-tags">tags</a>)
</pre>

Gets the lint config for a particular linter from the tags of a rule.

This will return either `None` or the label configured in `lint_setup`.
If the tags `no-lint` or `no-linter_name` (eg. `no-java-checkstyle`) are
found, then `None` will be returned. This allows linting to be turned off
for specific rules.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="get_lint_config-linter_name"></a>linter_name |  The "well known" name of the linter (eg. <code>java-checkstyle</code>)   |  none |
| <a id="get_lint_config-tags"></a>tags |  The tags from the rule (eg. <code>ctx.attr.tags</code>)   |  none |


<a id="#package_lint_config"></a>

## package_lint_config

<pre>
package_lint_config(<a href="#package_lint_config-linters">linters</a>)
</pre>

Register the given linters for the current bazel package.

This is expected to be near the top of the `BUILD.bazel` file and
allows users to override or configure specific linters for a bazel
package.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="package_lint_config-linters"></a>linters |  a dict of "well known name" to Label.   |  none |


