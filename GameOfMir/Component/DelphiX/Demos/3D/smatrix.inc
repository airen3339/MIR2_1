function SetMoveMatrix ( Xt, Yt, Zt: Single ): TD3DMatrix;
{Posunutie}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._11 := 1;
  Result._22 := 1;
  Result._33 := 1;
  Result._44 := 1;
  Result._41 := Xt;
  Result._42 := Yt;
  Result._43 := Zt;
end;

function SetRotateXMatrix ( Alpha: Single ): TD3DMatrix;
{Oto?enie okolo osi X}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._11 := 1;
  Result._44 := 1;
  Result._22 := cos (Alpha);
  Result._23 := sin (Alpha);
  Result._32 := -sin (Alpha);
  Result._33 := cos (Alpha);
end;

function SetRotateYMatrix ( Alpha: Single ): TD3DMatrix;
{Oto?enie okolo osi Y}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._22 := 1;
  Result._44 := 1;
  Result._11 := cos (Alpha);
  Result._13 := sin (Alpha);
  Result._31 := -sin (Alpha);
  Result._33 := cos (Alpha);
end;

function SetRotateZMatrix ( Alpha: Single ): TD3DMatrix;
{Oto?enie okolo osi Z}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._33 := 1;
  Result._44 := 1;
  Result._11 := cos (Alpha);
  Result._12 := sin (Alpha);
  Result._21 := -sin (Alpha);
  Result._22 := cos (Alpha);
end;

function SetScaleMatrix ( Sx, Sy, Sz: Single ): TD3DMatrix;
{Zmena mierky}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._11 := Sx;
  Result._22 := Sy;
  Result._33 := Sz;
  Result._44 := 1;
  Result._12 := 1;
  Result._13 := 1;
  Result._21 := 1;
{                           Sx  Sy  Sz
 S?mernos? pod?a osi x      +1  -1  -1
 S?mernos? pod?a osi y      -1  +1  -1
 S?mernos? pod?a osi z      -1  -1  +1
 S?mernos? pod?a roviny xy  +1  +1  -1
 S?mernos? pod?a roviny xz  +1  -1  +1
 S?mernos? pod?a roviny yz  -1  +1  +1
 Stredov? s?mernos?         -1  -1  -1}
end;

function SetShearYZMatrix ( SHy, SHz: Single ): TD3DMatrix;
{Zkosenie pod?a roviny YZ}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._11 := 1;
  Result._22 := 1;
  Result._33 := 1;
  Result._44 := 1;
  Result._12 := SHy;
  Result._13 := SHz;
end;

function SetShearXZMatrix ( SHx, SHz: Single ): TD3DMatrix;
{Zkosenie pod?a roviny XZ}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._11 := 1;
  Result._22 := 1;
  Result._33 := 1;
  Result._44 := 1;
  Result._21 := SHx;
  Result._23 := SHz;
end;

function SetShearXYMatrix ( SHx, SHy: Single ): TD3DMatrix;
{Zkosenie pod?a roviny XY}
begin
  FilLChar(Result, SizeOf(Result), 0);
  Result._11 := 1;
  Result._22 := 1;
  Result._33 := 1;
  Result._44 := 1;
  Result._31 := SHx;
  Result._32 := SHy;
end;
