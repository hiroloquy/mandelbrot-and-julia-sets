# Setting --------------------
reset
set term gif animate delay 4 size 1280, 720

set pm3d map at s
set margins 0, 0, 0, 0
unset key
unset grid
set ticslevel 0
unset colorbox

# Palette
set palette defined (0 '#000090',1 '#000fff',2 '#0090ff',\
                     3 '#0fffee', 4 '#90ff70', 5 '#ffee00',\
                     6 '#ff7000',7 '#ee0000',8 '#7f0000')
# set palette cubehelix start 1 cycles -5 saturation 3 positive     # cube
# set palette defined(0"black", 1"red", 2"white", 3"black")         # black

# Axes
set xl 'Re' font 'Times New Roman, 18'
set yl 'Im' font 'Times New Roman, 18'
unset zl
set tics font 'Times New Roman, 18'
set ztics 20

# Samples
set samples 700
set isosamples 700, 700

# Parameter
T = 360           # period [step]
omega = 2*pi/T


# Function --------------------
complex(a,b) = a*{1,0} + b*{0,1}
Mandel(x, y, z, n) = (abs(z)>2 || n<=0) ? 0 : Mandel(x, y, z*z+complex(x,y), n-1) + 1
Julia(x, y, z, n)  = (abs(z)>2 || n<=0) ? 0 : Julia(x, y, z*z+complex(x,y), n-1) + 1

# Cardioid
xCardioid(i) = 0.5*cos(omega*i)*(1-cos(omega*i)) + 0.25
yCardioid(i) = 0.5*sin(omega*i)*(1-cos(omega*i))

# Circle
r = 0.7211
xCircle(i) = r*cos(omega*i)
yCircle(i) = r*sin(omega*i)


# Plot --------------------
path = "cardioid"                   # Select "cardioid" or "circle"
filename = sprintf("multiplot_path=%s.gif", path)
set output filename

N = 100                             # Recursion limit (max: 250)

do for[i=0:T-1]{
    # Calculate position of c       # ex.) path = "Cardioid"
    eval "a = x".path."(i)"         #   a = xCardioid(i)
    eval "b = y".path."(i)"         #   b = yCardioid(i)

    set multiplot
    # Left side
        set origin 0.05, 0.15
        set size 0.45, 0.8
        set obj 1 circ at a, b, 100 front size 0.03 fc rgb "orange" fs solid noborder # or 'light-green'
        splot [-2:1][-1.5:1.5][0:100] Mandel(x, y, complex(0, 0), N)

    # Right side
        set origin 0.53, 0.15
        set size 0.45, 0.8
        unset obj 1
        splot [-1.5:1.5][-1.5:1.5][0:100] Julia(a, b, complex(x,y), N)
    unset multiplot
}

set out