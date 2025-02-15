PRO fpi_gyroasy,tname,range=range,tavg=tavg,full_out=full_out,datagap=datagap

  if undefined(range) then range=1.25d

  get_data,tname,data=d,lim=l
  dnum_orig=n_elements(d.v)
  if d.v[dnum_orig-1] ge 360.d then dnum=dnum_orig-1 else dnum=dnum_orig
  if not undefined(tavg) then d_orig=d
  
  for i=0,n_elements(d.x)-1 do begin
    avg=total(d.y[i,0:dnum-1])/double(dnum)
    for j=0,dnum_orig-1 do begin
      if d.y[i,j] gt 0.d then d.y[i,j]=d.y[i,j]/avg else d.y[i,j]=1e-31
    endfor
  endfor

  if undefined(datagap) then datagap=1.1d*(d.x[1]-d.x[0])

  store_data,tname+'_ratio',data={x:d.x,y:d.y,v:d.v},lim=l
  options,tname+'_ratio',spec=1,datagap=datagap,color_table=0,yticks=4,zticks=1,ystyle=1,yrange=[0.d,360.d],zstyle=1,zrange=[1.d/range,range],zlog=1

  if not undefined(tavg) then begin
    y=smooth_in_time(d_orig.y,d_orig.x,tavg)
    d_avg={x:d_orig.x,y:y,v:d_orig.v}
    if not undefined(full_out) then begin
      store_data,tname+'_avg',data=d_avg
      options,tname+'_avg',spec=1,datagap=datagap,yticks=4,zticks=1,ystyle=1,yrange=[0.d,360.d]
    endif
    for i=0l,n_elements(d_avg.x)-1 do begin
      avg=total(d_avg.y[i,0:dnum-1])/double(dnum)
      for j=0l,dnum_orig-1 do begin
        if d_avg.y[i,j] gt 0.d then d_avg.y[i,j]=d_avg.y[i,j]/avg else d_avg.y[i,j]=1e-31
      endfor
    endfor
    store_data,tname+'_ratio_avg',data=d_avg
    options,tname+'_ratio_avg',spec=1,datagap=datagap,color_table=0,yticks=4,zticks=1,ystyle=1,yrange=[0.d,360.d],zstyle=1,zrange=[1.d/range,range],zlog=1
  endif

END