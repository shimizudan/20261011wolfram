# Julia から Wolfram Engine を使う — 高校数学のノートブック集

Julia の Jupyter ノートブックから [Wolfram Engine](https://www.wolfram.com/engine/) を呼び出し，**記号計算の厳密な結果を Julia で使う**ためのサンプル集です。

- Wolfram に積分・微分・方程式などを厳密に解かせる
- 結果を $\LaTeX$ 組版（教科書に近い見た目）で表示する
- 結果を **Julia の関数・値・配列**に変換して，数値計算やグラフに使う

たとえば不定積分なら，次のように書けます。

```julia
Fw, F = indefinite("x^2 Sin[x]")     # ∫ x² sin x dx = 2x sin x − (x² − 2) cos x + C と表示される
F(1.0)                               # 結果は普通の Julia の関数として使える
plot(F, -2π, 2π)
```

Julia と Wolfram の橋渡しには [MathLink.jl](https://github.com/JuliaInterop/MathLink.jl) を使っています。

## ノートブック一覧

| 分野 | ファイル | 主な内容 |
|---|---|---|
| 積分 | [julia_wolfram_integral.ipynb](julia_wolfram_integral.ipynb) | 不定積分を Julia の関数に，定積分の厳密値，数値積分との照合 |
| 微分 | [julia_wolfram_derivative.ipynb](julia_wolfram_derivative.ipynb) | 導関数・高階導関数，接線，ニュートン法，極値，偏微分，テイラー展開 |
| 方程式・不等式 | [julia_wolfram_equation.ipynb](julia_wolfram_equation.ipynb) | 厳密解を配列に，連立方程式，不等式の解を判定関数に，領域と最大・最小 |
| 数列・和・極限 | [julia_wolfram_sequence.ipynb](julia_wolfram_sequence.ipynb) | $\sum$ の公式，漸化式の一般項，極限，無限級数 |
| 確率・統計 | [julia_wolfram_probability.ipynb](julia_wolfram_probability.ipynb) | 厳密な確率・期待値と乱数シミュレーションの比較，正規近似，信頼区間 |
| 複素数平面 | [julia_wolfram_complex.ipynb](julia_wolfram_complex.ipynb) | 極形式，ド・モアブルの定理，$z^n = \alpha$，回転，軌跡 |
| 微分方程式 | [julia_wolfram_ode.ipynb](julia_wolfram_ode.ipynb) | 厳密解，方向場，オイラー法などとの誤差の比較，応用 |
| ベクトル・図形 | [julia_wolfram_vector.ipynb](julia_wolfram_vector.ipynb) | 内積・なす角，三角形の五心，直線と円，空間の平面・距離・体積 |
| 式変形 | [julia_wolfram_algebra.ipynb](julia_wolfram_algebra.ipynb) | 展開・因数分解，部分分数分解，有理化，三角関数の変形，恒等式 |
| 線形代数 | [julia_wolfram_linalg.ipynb](julia_wolfram_linalg.ipynb) | 行列式・逆行列，固有値，対角化，行列の $n$ 乗，1 次変換 |
| 整数 | [julia_wolfram_integer.ipynb](julia_wolfram_integer.ipynb) | 素因数分解，不定方程式の整数解，合同式，循環小数，連分数，素数 |

どのノートブックも実行結果つきで保存してあるので，GitHub 上でそのまま内容を確認できます。  
どれから読んでもかまいませんが，最初は積分編がおすすめです。

## 入試問題を解く — 京都大学 2026 理系

分野別のノートブックで用意した道具を使って，実際の入試問題（京都大学 2026 年度 理系数学，全 6 問）を解いたノートブックです。

最初から答えを出すのではなく，**グラフをかく → 予想を立てる → Wolfram で厳密に計算する → Julia で検算する**，という順に少しずつ進めています。Wolfram と Julia を「考えるための道具」として使う例として読んでください。

| 問題 | ファイル | 題材 | 進め方 |
|---|---|---|---|
| 第1問 | [julia_wolfram_kyoto2026_1.ipynb](julia_wolfram_kyoto2026_1.ipynb) | 微分・グラフと定数 $k$ の共有点の個数 | いくつかの $a$ でグラフをかく → 微分して増減と極小値を調べる → 両端の極限 → 共有点が 2 個になる $(a,\ k)$ を図示 |
| 第2問 | [julia_wolfram_kyoto2026_2.ipynb](julia_wolfram_kyoto2026_2.ipynb) | 空間図形（正四面体と球面） | 座標を設定して点を媒介変数で表す → 距離の 2 乗を計算 → 最短・最長の距離から境界を調べる → `ForAll`，`Exists` で条件をそのまま解いて確認 |
| 第3問 | [julia_wolfram_kyoto2026_3.ipynb](julia_wolfram_kyoto2026_3.ipynb) | 整数・多項式の係数（証明問題） | 小さい $n$ で展開・因数分解して規則を見つける → 二項定理で係数が $2$ で何回割り切れるかを調べる → 因数分解を使った帰納法で証明 |
| 第4問 | [julia_wolfram_kyoto2026_4.ipynb](julia_wolfram_kyoto2026_4.ipynb) | 平面図形（正方形を含む正三角形）の最小値 | 正方形を固定し，正三角形を法線と距離で表す → 1 辺の長さを向き $\theta$ の関数にする → グラフと図で確かめて最小値を求める |
| 第5問 | [julia_wolfram_kyoto2026_5.ipynb](julia_wolfram_kyoto2026_5.ipynb) | 積分（回転体の体積） | 共有点を求める → いくつかの $a$ で領域をかく → $x$ 軸で折り返して場合分けの境目を探す → 区間ごとに積分 → 数値積分で検算 |
| 第6問 | [julia_wolfram_kyoto2026_6.ipynb](julia_wolfram_kyoto2026_6.ipynb) | 確率・期待値 | $P(X = n)$ を求める → $P(X = k)$ と期待値を `Sum` で計算 → すべての場合の数え上げとシミュレーションで検算 |

- 各ノートブックの最初に問題文があります。
- Wolfram や Julia で確かめているのは，小さい場合の実験や数値での検算です。第3問のような証明問題では，実験で見つけた規則をもとに，証明は文章で書いています。
- 分野別のノートブックと同じく `wolfram_common.jl` を読み込みます。問題ごとの補助関数は，それぞれのノートブックの中で定義しています。

## 必要なもの

- [Julia](https://julialang.org/)
- [Wolfram Engine](https://www.wolfram.com/engine/)（無料で入手できます。インストール後にアクティベートが必要です）
- Jupyter ノートブックを開く環境（VS Code + Jupyter 拡張機能 など）と，Julia のカーネル（[IJulia.jl](https://github.com/JuliaLang/IJulia.jl)）

Wolfram Engine が使える状態かどうかは，ターミナルで次を実行して確かめられます。

```
wolframscript -code '1+1'
```

## 準備

Julia で，使うパッケージを追加します。

```julia
import Pkg
Pkg.add(["IJulia", "MathLink", "SpecialFunctions", "Plots"])

# グラフで日本語を使うためのパッケージ（GitHub から直接追加する）
Pkg.add(url="https://github.com/ujimushi/PlotsGRBackendFontJaEmoji.jl")

# ノートブックによって追加で使うもの
Pkg.add(["QuadGK", "Distributions", "Primes"])
```

| パッケージ | 使うノートブック |
|---|---|
| MathLink, SpecialFunctions, Plots | すべて |
| [PlotsGRBackendFontJaEmoji](https://github.com/ujimushi/PlotsGRBackendFontJaEmoji.jl) | すべて（グラフの凡例・軸ラベルを日本語で表示する） |
| QuadGK | 積分，京都大学 2026 第5問 |
| Distributions | 確率・統計 |
| Primes | 整数 |

MathLink.jl が Wolfram Engine を見つけられない場合は，[MathLink.jl の説明](https://github.com/JuliaInterop/MathLink.jl#installation-troubleshoot)にしたがって環境変数 `JULIA_MATHKERNEL`，`JULIA_MATHLINK` を設定し，`Pkg.build("MathLink")` を実行してください。

## 使い方

1. このリポジトリをダウンロードします（フォルダごと）。
2. ノートブックを開き，Julia のカーネルを選んで，上のセルから順に実行します。

各ノートブックは最初に共通ファイルを読み込みます。**`wolfram_common.jl` はノートブックと同じフォルダに置いてください。**

```julia
include("wolfram_common.jl")
```

## 共通ファイル `wolfram_common.jl`

表示と変換のための関数をまとめたファイルです。自分のノートブックでも `include` すれば使えます。

| 関数 | はたらき |
|---|---|
| `tex(w)` | Wolfram の式 → $\LaTeX$ 文字列 |
| `heldtex("式")` | Wolfram 言語の文字列 → 評価せずに $\LaTeX$ 文字列（入力した形のまま） |
| `showtex("...")` | $\LaTeX$ 文字列をディスプレイ数式として表示 |
| `to_expr(w)` | Wolfram の式 → Julia の式（`Expr`） |
| `to_value(w)` | Wolfram の式 → Julia の値 |
| `to_function(w, :x, ...)` | Wolfram の式 → Julia の関数 |
| `to_matrix(w)` | Wolfram の行列 → Julia の行列 |
| `wN(w, 桁数)` | 高精度の数値（`BigFloat`） |

```julia
include("wolfram_common.jl")

w = weval(W`Integrate[Exp[-x^2], {x, -Infinity, Infinity}]`)    # 厳密値 √π
showtex(tex(w))                                                 # 数式として表示
to_value(w)                                                     # 1.7724538509055159

d = weval(W`D[x^2 Sin[x], x]`)
f = to_function(d, :x)                                          # Julia の関数
f(1.0)
```

変換できる Wolfram の関数は，対応表 `WFUNC` に登録されています。登録されていない関数が結果に現れるとエラーになるので，次のように追加します。

```julia
WFUNC["BesselJ"] = :besselj
```

分野ごとの関数（`solve`，`dsolve`，`prob`，`calc` など）は，それぞれのノートブックの中で定義しています。

## 注意

- **同時に起動できるカーネル数**：無料版の Wolfram Engine は，同時に起動できるカーネル数に上限があります。別のノートブックや `wolframscript` が動いたままだと，`AssertionError: nextpacket(...)` というエラーで接続に失敗します。使い終わったカーネルは停止してください。
- **整数の桁あふれ**：Julia の `Int` は 64 ビットです。大きな数を扱うときは `big(n)` を使います（各ノートブックの「うまくいかないとき」に例があります）。
- **すべての式が変換できるわけではありません**：Wolfram が閉じた式で答えを返せない場合や，Julia に対応する関数がない場合は，エラーで知らせます。
- **Wolfram 言語の書き方**：関数の引数は角かっこ `Sin[x]`，等号は `==`，虚数単位は `I`，円周率は `Pi` です。

## 動作を確認した環境

- macOS（Apple シリコン）
- Julia 1.13.1
- Wolfram Engine 15.0.0
- MathLink.jl 0.6.3
- PlotsGRBackendFontJaEmoji.jl 0.1.0

すべてのノートブックを，この環境で最初から最後まで実行して確認しています。

## ライセンス

[MIT ライセンス](LICENSE)です。授業や教材づくりに自由に使ってください。

入試問題の著作権は出題した大学にあります。ノートブックでは，解説のために問題文を引用しています。

---

Wolfram，Mathematica，Wolfram Engine は Wolfram Research, Inc. の商標です。このリポジトリは Wolfram Research とは関係のない個人の教材です。
