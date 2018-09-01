# Graphviz Redmine plugin

This plugin will allow adding [Graphviz](https://www.graphviz.org/) diagrams into Redmine.

## Requirements

- Graphviz binary

## Installation

- copy this plugin into the Redmine plugins directory

1. `cd <path/to/redmine>/plugins`
2. `git clone https://github.com/wate/graphviz.git`
3. restart Redmine

## Usage

- go to the [plugin settings page](http://localhost:3000/settings/plugin/graphviz) and add the *Graphviz binary* path `/usr/bin/dot`
- Graphviz diagrams can be added as follow:

```
{{graphviz(png)
digraph G {
  graph [
     rankdir = "TB"
  ];
  未対応 -> 対応中 -> 対応済み -> 完了;
  未対応 -> 破棄;
  対応済み -> フィードバック;
  フィードバック -> 対応中;
  フィードバック -> 対応済み;
}
}}
```

```
{{graphviz(svg)
digraph G {
  graph [
     rankdir = "LR"
  ];
  未対応 -> 対応中 -> 対応済み -> 完了;
  未対応 -> 破棄;
  対応済み -> フィードバック;
  フィードバック -> 対応中;
  フィードバック -> 対応済み;
}
}}
```

- you can choose between PNG or SVG images by setting the `graphviz` macro argument to either `png` or `svg`

## using !include params

Since all files are written out to the system, there is no safe way to prevent editors from using the `!include` command inside the code block.
Therefore every input will be sanitited before writing out the .dot files for further interpretation. You can overcome this by activating the `Setting.plugin_graphviz['allow_includes']`
**Attention**: this is dangerous, since all files will become accessible on the host system.

## TODO

- add image caching

## Acknowledge

This plugins is based on [dkd/plantuml](https://github.com/dkd/plantuml).

## License

MIT License
