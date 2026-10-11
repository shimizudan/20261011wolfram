# wolfram_common.jl
# Julia から Wolfram Engine を使うための共通の関数（各ノートブックの最初で include する）
#
#   include("wolfram_common.jl")
#
# 提供するもの
#   tex(w)                  Wolfram の式 → LaTeX 文字列
#   heldtex("式")           Wolfram 言語の文字列 → 評価せずに LaTeX 文字列
#   showtex("LaTeX")        ディスプレイ数式として表示
#   wparse("式")            Wolfram 言語の文字列 → 未評価の式（WExpr）
#   to_expr(w)              Wolfram の式 → Julia の式（Expr）
#   to_value(w)             Wolfram の式 → Julia の値
#   to_function(w, :x, ...) Wolfram の式 → Julia の関数
#   to_matrix(w)            Wolfram の行列（リストのリスト）→ Julia の行列
#   to_matrix_function(w, :x, ...)   行列を返す Julia の関数
#   WFUNC, WCONST           Wolfram → Julia の対応表（足りない関数は WFUNC["名前"] = :関数 で追加）

using MathLink            # Wolfram Engine との通信
using SpecialFunctions    # erf, gamma, zeta など（Wolfram の結果に特殊関数が出たとき用）

# ───────────────────────── 表示 ─────────────────────────

# Wolfram 言語の文字列 → 未評価の式
wparse(s::AbstractString) = MathLink.parseexpr(s)

# Wolfram の式 → LaTeX 文字列（TeXForm は TraditionalForm の組版を LaTeX にしたもの）
tex(w) = weval(W"ToString"(W"TeXForm"(w)))
tex(x::Number) = string(x)
tex(x::AbstractFloat) = string(round(x; sigdigits=6))

# Wolfram 言語の文字列 → 評価せずに LaTeX 文字列（入力した形のまま表示する）
heldtex(s::AbstractString) = tex(W"HoldForm"(wparse(s)))

# LaTeX 文字列をディスプレイ数式として表示
showtex(s::AbstractString) = display("text/latex", "\$\$" * s * "\$\$")

# ───────────────────── 変換で使う Julia の関数 ─────────────────────

# 累乗：整数の負べきは分数で厳密に（2^(-3) → 1//8），負の実数の分数乗は複素数で計算する
pw(b, p) = b^p
pw(b, p::Integer) = p >= 0 ? b^p : inv(b)^(-p)                       # π^(-2) など
pw(b::Integer, p::Integer) = p >= 0 ? b^p : (1 // b)^(-p)
pw(b::Real, p::Rational) = b < 0 ? complex(float(b))^p : b^p

# 分母が 1 の分数は整数に直す（385//1 → 385）
tidy(x) = x
tidy(x::Rational) = isone(denominator(x)) ? numerator(x) : x
tidy(x::AbstractArray{<:Rational}) = all(isone ∘ denominator, x) ? numerator.(x) : x      # 配列も同様に
tidy(x::AbstractArray{<:AbstractArray}) = map(tidy, x)

# Wolfram の結果に名前つきで現れる数列
harmonic(n::Integer) = sum(one(n) // k for k in 1:n; init=zero(n) // one(n))    # 調和数 H_n
function fibonacci(n::Integer)                                                  # フィボナッチ数 F_n
    a, b = zero(n), one(n)
    for _ in 1:n
        a, b = b, a + b
    end
    return a
end

# ───────────────────────── 対応表 ─────────────────────────

# Wolfram の関数名 → Julia の関数名
const WFUNC = Dict{String,Any}(
    "Plus" => :+, "Times" => :*, "Rational" => ://, "Complex" => :complex,
    "Sqrt" => :sqrt, "Exp" => :exp, "Log" => :log, "Abs" => :abs, "Sign" => :sign,
    "Sin" => :sin, "Cos" => :cos, "Tan" => :tan, "Cot" => :cot, "Sec" => :sec, "Csc" => :csc,
    "ArcSin" => :asin, "ArcCos" => :acos, "ArcTan" => :atan,
    "Sinh" => :sinh, "Cosh" => :cosh, "Tanh" => :tanh, "Coth" => :coth, "Sech" => :sech, "Csch" => :csch,
    "ArcSinh" => :asinh, "ArcCosh" => :acosh, "ArcTanh" => :atanh,
    "Arg" => :angle, "Re" => :real, "Im" => :imag, "Conjugate" => :conj,
    "Max" => :max, "Min" => :min, "Floor" => :floor, "Ceiling" => :ceil,
    "Mod" => :mod, "GCD" => :gcd, "LCM" => :lcm,
    "Binomial" => :binomial, "Factorial" => :factorial,
    "HarmonicNumber" => :harmonic, "Fibonacci" => :fibonacci,
    # SpecialFunctions.jl の関数
    "Erf" => :erf, "Erfc" => :erfc, "Erfi" => :erfi, "InverseErf" => :erfinv, "InverseErfc" => :erfcinv,
    "Gamma" => :gamma, "Beta" => :beta, "PolyGamma" => :polygamma, "Zeta" => :zeta,
    "ExpIntegralEi" => :expinti, "SinIntegral" => :sinint, "CosIntegral" => :cosint,
)

# Wolfram の比較演算 → Julia の比較演算
const WCMP = Dict("Less" => :<, "LessEqual" => :<=, "Greater" => :>, "GreaterEqual" => :>=,
                  "Equal" => :(==), "Unequal" => :(!=))

# Wolfram の定数 → Julia の定数
const WCONST = Dict{String,Any}(
    "Pi" => :π, "E" => :ℯ, "I" => :im, "Infinity" => :Inf, "Indeterminate" => :NaN,
    "EulerGamma" => :(MathConstants.γ), "GoldenRatio" => :(MathConstants.φ), "Catalan" => :(MathConstants.catalan),
    "True" => true, "False" => false,
)

# 評価されずに戻ってきた（＝ Wolfram が閉じた式で求められなかった）ことを表す頭部
const WUNEVALUATED = ("Integrate", "Sum", "Product", "Limit", "Solve", "Reduce", "RSolve", "DSolve",
                      "ReplaceAll", "Probability", "Expectation", "InverseFunction")

# ───────────────────── Wolfram の式 → Julia の式 ─────────────────────

islist(w) = w isa MathLink.WExpr && w.head == W"List"
isrule(w) = w isa MathLink.WExpr && w.head == W"Rule"

to_expr(x::Number) = x
to_expr(x::MathLink.WInteger) = parse(BigInt, x.value)                 # 巨大な整数
function to_expr(x::MathLink.WReal)                                    # 任意精度実数 → BigFloat
    m = match(r"`([\d.]+)", x.value)                                   # 「数値`桁数」の桁数を読む
    bits = m === nothing ? 256 : ceil(Int, parse(Float64, m[1]) * log2(10))
    parse(BigFloat, replace(replace(x.value, r"`[^*]*" => ""), "*^" => "e"); precision=bits)
end
to_expr(s::MathLink.WSymbol) = get(WCONST, s.name, Symbol(s.name))
to_expr(s::AbstractString) = s

function to_expr(w::MathLink.WExpr)
    w.head isa MathLink.WSymbol || error("Julia に変換できない式です（未定義関数の導関数など）: $w")
    h = w.head.name
    a = w.args
    h in WUNEVALUATED && error("Wolfram が閉じた式で求められませんでした（発散する，解けない，など）: $w")

    if h == "List"
        if !isempty(a) && all(isrule, a)                               # {x -> 1, y -> 2} → (x = 1, y = 2)
            return Expr(:tuple, (Expr(:(=), to_expr(r.args[1]), to_expr(r.args[2])) for r in a)...)
        end
        return Expr(:vect, to_expr.(a)...)                             # {..} → ベクトル（入れ子はベクトルのベクトル）
    elseif h == "C"
        return Symbol("C", a[1])                                       # 任意定数 C[1] → C1
    elseif h in ("Sphere", "Circle", "Ball", "Disk")
        return Expr(:tuple, to_expr.(a)...)                            # Sphere[中心, 半径] → (中心, 半径)

    # ── 累乗 ──
    elseif h == "Power"
        b, p = a
        b == W"E" && return :(exp($(to_expr(p))))                      # E^p   → exp(p)
        p == W"Rational"(1, 2)  && return :(sqrt($(to_expr(b))))       # b^(1/2)  → sqrt(b)
        p == W"Rational"(-1, 2) && return :(1 / sqrt($(to_expr(b))))   # b^(-1/2) → 1/sqrt(b)
        p isa Integer && p > 0  && return :($(to_expr(b))^$p)          # b^2 など
        return :(pw($(to_expr(b)), $(to_expr(p))))                     # それ以外は pw
    elseif h == "Times" && a[1] == -1 && length(a) == 2
        return :(-$(to_expr(a[2])))                                    # -1*y → -y
    elseif h == "ArcTan" && length(a) == 2
        return :(atan($(to_expr(a[2])), $(to_expr(a[1]))))             # ArcTan[x, y] = atan(y, x)
    elseif h == "DirectedInfinity"
        return :($(to_expr(a[1])) * Inf)                               # ∞, -∞

    # ── 条件式・場合分け ──
    elseif h == "Or"
        return foldr((p, q) -> Expr(:||, p, q), to_expr.(a))           # p || q
    elseif h == "And"
        return foldr((p, q) -> Expr(:&&, p, q), to_expr.(a))           # p && q
    elseif h == "Not"
        return :(!$(to_expr(a[1])))
    elseif haskey(WCMP, h)                                             # a < b,  a <= b <= c
        e = Any[to_expr(a[1])]
        for t in a[2:end]
            push!(e, WCMP[h], to_expr(t))
        end
        return Expr(:comparison, e...)
    elseif h == "Inequality"                                           # -1 < x <= 2
        return Expr(:comparison, (isodd(i) ? to_expr(a[i]) : WCMP[a[i].name] for i in eachindex(a))...)
    elseif h == "Piecewise"                                            # 場合分け → 条件 ? 値 : それ以外
        ex = length(a) >= 2 ? to_expr(a[2]) : 0
        for c in reverse(a[1].args)
            ex = Expr(:if, to_expr(c.args[2]), to_expr(c.args[1]), ex)
        end
        return ex
    elseif h == "ConditionalExpression"
        @warn "条件つきの結果です（条件は無視します）" 条件 = a[2]
        return to_expr(a[1])
    elseif h == "Root"
        error("Root オブジェクト（根号で簡単に表せない解）です。N[...] で数値にしてください。")
    end

    haskey(WFUNC, h) || error("未対応の Wolfram 関数 $h です。WFUNC[\"$h\"] = :Juliaの関数名 で対応を追加してください。")
    Expr(:call, WFUNC[h], to_expr.(a)...)
end

# ───────────────────── Julia の値・関数にする ─────────────────────

# 式 → Julia の値（定積分の結果など，変数を含まないもの）
to_value(w) = tidy(Core.eval(Main, to_expr(w)))

# 式 → Julia の関数（vars に変数名を並べる）
# invokelatest で包むのは，作った直後（同じ文・同じループの中）でも呼べるようにするため
function to_function(w, vars::Symbol...)
    f = Core.eval(Main, Expr(:->, Expr(:tuple, vars...), to_expr(w)))
    return (args...) -> tidy(Base.invokelatest(f, args...))
end

# Wolfram 言語の文字列で書いた関数・条件 → Julia の関数
wfun(f::AbstractString, vars::Symbol...) = to_function(weval(wparse(f)), vars...)

# 行列（リストのリスト）→ Julia の行列
to_matrix(w) = tidy(stack(to_value(w); dims=1))
function to_matrix_function(w, vars::Symbol...)
    f = to_function(w, vars...)
    return (args...) -> tidy(stack(f(args...); dims=1))
end

# 高精度の数値：Wolfram の N[式, 桁数] → BigFloat
wN(w, digits=50) = to_value(weval(W"N"(w, digits)))

# 根号で簡単に表せない解（Root オブジェクト）を含むか
hasroot(w) = occursin("Root[", string(w))
