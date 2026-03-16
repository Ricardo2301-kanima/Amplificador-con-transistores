% valores default
mili = 10^-3;
micro = 10^-6;
kilo = 10^3;
mega = 10^6;

% Valores en el circuito
vcc = 12; % V
vca = 10 * mili; % V
fmin = 60; % hz


function rent = colectorcomun(vcc, fmin, ganancia, ic, hfe, rl)

    if nargin < 6
        rl = 100000;
    end

    mili = 10^-3;
    micro = 10^-6;
    kilo = 10^3;

    % parametros de diseño
    vce = vcc/2;
    ve = 1;
    vc = vcc-(vce-ve);
    vbe = 0.7;
    vb = vbe + ve;

    re = ve/ic;
    rc = vc/ic;

    ib = ic/hfe;
    ir1 = ib * 10;
    ir2 = ir1 - ib;

    r1 = (vcc-vb)/ir1;
    r2 = vb/ir2;

    % caso en AC
    vt = 26*mili;
    xc = re/10;
    r_e = vt/ic;

    rb = (r1*r2)/(r1+r2);
    rent_parcial = hfe*(re+r_e);
    rent = (rb*rent_parcial)/(rb+rent_parcial);

    cap = (1/(2*pi*fmin*xc));

    % ganancia
    rl_total = (rc*rl)/(rc+rl);
    re_gain = (rl_total/ganancia) - r_e;

    % saturación
    ic_sat = vcc/(rc+re);

    fprintf('re = %gk, rc = %gk, r1 = %gk, r2 = %gk \n', re/kilo, rc/kilo, r1/kilo, r2/kilo);
    fprintf('impedancia de entrada = %gk \n', rent/kilo);
    fprintf('cap = %guF, resistencia para ganancia = %g \n', cap/micro, re_gain);
    fprintf('Isat %g \n\n', ic_sat);

end

rin3 = colectorcomun(vcc, fmin, 10, 1*mili, 100);
rin2 = colectorcomun(vcc, fmin, 8, 1*mili, 100, rin3);
rin1 = colectorcomun(vcc, fmin, 5, 1*mili, 100, rin2);

function darlinton(vcc, rl, hfe1, hfe2, fmin)
kilo = 10^3;
beta_total = hfe1 * hfe2;

vbe = 1.3;
ve = vcc/2;
vb = ve + vbe;

i_max = ve / rl;
ib = i_max / beta_total;
ir2 = ib * 10;
ir1 = ir2 + ib;


re = ve / i_max;
r2 = vb / ir2;
r1 = (vcc - vb) / ir1;

xc = rl / 10;
cap = 1/(2*pi*fmin*xc);

fprintf("Beta total = %g\n", beta_total);
fprintf("Ve = %g V\n", ve);
fprintf("Re ≈ %g ohm\n", re);
fprintf("R1 = %g kΩ\n", r1/kilo);
fprintf("R2 = %g kΩ\n", r2/kilo);
fprintf("Capacitor salida ≈ %g uF\n", cap/1e-6);
fprintf("Corriente máxima ≈ %g A\n", i_max);

end

darlinton(12, 8, 100, 100, 60);