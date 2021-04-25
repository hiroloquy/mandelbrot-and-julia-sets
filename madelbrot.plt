# Setting --------------------
reset
set term gif animate delay 6 size 1280, 720
set output "mandelbrot.gif"
set margins 0, 0, 0, 0
unset key
unset grid
set ticslevel 0
unset surface

# Palette
set palette defined(0"#000099",1"#ffffff",2"#000000")

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
compl(a, b) = a*{1, 0}+b*{0, 1}
mand(z, a, n) = (n<=0 || abs(z)>2)? 0: mand(z*z+a, a, n-1) + 1

# Display "c-plane"
set label 1 center "{/TimesNewRoman:Italic c} - plane"\
    font 'Times New Roman, 22' at screen 0.755, 0.802

# Plot --------------------
ang = 209       # Initiate angle
N = 100         # Recursion limit (max: 250)

do for[k=1:360]{
    set multiplot

    # Left side
        # Rotate
        ang = ang + 360
        if(ang>=360){
            ang = ang - 360
        }
        set view 45, ang, 1, 1

        set origin 0.01,0.03
        set size 0.55, 0.94
        set pm3d at s
        unset colorbox
        set zl 'N' offset 1 font 'Times New Roman:Italic, 18'
        splot [-2:1][-1.5:1.5] mand({0, 0}, compl(x, y), N)

    # Right side
        set pm3d map
        set origin 0.55,0.117
        set size 0.43, 0.764
        set colorbox
        unset zl
        splot [-2:1][-1.5:1.5] mand({0, 0}, compl(x, y), N)

    unset multiplot
}

set out