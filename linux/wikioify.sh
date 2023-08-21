# Use pandoc to convert markdown into HTML, with a <details> footer explaining
# how to use pandoc to convert markdown into HTML.
# TODO: Error when `pandoc` or `jq` are not installed
function wikioify {
cat << EOF
$(pandoc ${1} -t html)

<hr>

<details>
  <summary>Original Markdown</summary>
  Generated with
  <pre><code>pandoc \${1} -t html

&lt;hr&gt;

&lt;details&gt;
  &lt;summary&gt;Original Markdown&lt;/summary&gt;
  Generated with
  &lt;pre&gt;&lt;code&gt;\$(cat \${1} | jq -rR &apos;@html&apos;)&lt;/code>&lt;/pre&gt;
&lt;/details&gt;</pre></code>
  <pre><code>$(cat ${1} | jq -rR '@html')</code></pre>
</details>
EOF
}
