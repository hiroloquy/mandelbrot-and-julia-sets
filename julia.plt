# Setting --------------------
reset
set term gif animate delay 6 size 1280, 720
set output "julia.gif"

set margins 0, 0, 0, 0
unset key
unset grid
set ticslevel 0
unset surface

# Palette
set palette rgb 7, 5, 15

# Axes
set xl 'Re' font 'Times New Roman, 18'
set yl 'Im' font 'Times New Roman, 18'
set tics font 'Times New Roman, 18'
set ztics 20
set cbtics 20

# Samples
set samples 700
set isosamples 700, 700


# Function --------------------
complex(x, y)=x*{1, 0}+y*{0, 1}
julia(x, y, z, n) = (abs(z)>2 || n<=0) ? 0 : julia(x, y, z*z+complex(x,y), n-1) + 1

# Select c=a+bi (c: complex constant)
a = -0.790
b = 0.150

# Display "z0-plane"
set label 1 center "{/TimesNewRoman:Italic z_{/TimesNewRoman:Normal 0}} - plane"\
    font 'Times New Roman, 22' at screen 0.755, 0.85

# Display c
if(a!=0 && b!=0){
    c = sprintf("%.2f%+.2f", a, b)
    set label 2 center "({/TimesNewRoman:Italic c} = ".c."{/TimesNewRoman:Italic i})" \
        font 'Times New Roman, 20' at screen 0.755, 0.802
}
if(a==0){ # Pure imaginary number
    c = sprintf("%.2f", b)
    set label 2 center "({/TimesNewRoman:Italic c} = ".c."{/TimesNewRoman:Italic i})" \
        font 'Times New Roman, 20' at screen 0.755, 0.802
}
if(b==0){ # Real number
    c = sprintf("%.2f", a)
    set label 2 center "({/TimesNewRoman:Italic c} = ".c.")" \
        font 'Times New Roman, 20' at screen 0.755, 0.802
}


# Plot --------------------
ang = 209       # Initiate angle
N = 100         # Recursion limit (max: 250)

do for[k=1:360]{
    set multiplot

    # Left side
        # Rotate
        ang = ang + 1
        if(ang>=360){
            ang = ang - 360
        }
        set view 45, ang, 1, 1

        set origin 0.01, 0.03
        set size 0.55, 0.94
        set pm3d at s
        unset colorbox
        set zl 'N' offset 1 font 'Times New Roman:Italic, 18'
        splot [-1.5:1.5][-1.5:1.5] julia(a, b, complex(x, y), N)

    # Right side
        set pm3d map
        set origin 0.55 ,0.117
        set size 0.43, 0.764
        set colorbox
        unset zl
        splot [-1.5:1.5][-1.5:1.5] julia(a, b, complex(x, y), N)

    unset multiplot
}

set out