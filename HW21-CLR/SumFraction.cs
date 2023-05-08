using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


[SqlUserDefinedAggregate(Format.Native)]
public struct SumFraction
{
    private Int64 enumerator;
    private Int64 denominator;
    public void Init()
    {
        enumerator = 0;
        denominator = 0;
    }

    public void Accumulate(SqlString value)
    {
        if (value.IsNull)
            return;

        String fract = value.ToString();

        //Для полной дроби может быть 1/1
        if (fract.Equals("1")) fract = "1/1";

        //Добавляем дробь
        accumFract(fract);
    }

    public void Merge(SumFraction group)
    {
        accumFract(group.getFraction().ToString());
    }

    public SqlString Terminate()
    {
        return getFraction();
    }

    private void accumFract(String fraction)
    {
        if (fraction == null) return;

        if (fraction.Contains("/"))
        {
            
            String[] ed = fraction.Split('/');           
            Int64.TryParse(ed[0], out Int64 fractEnum);
            Int64.TryParse(ed[1], out Int64 fractDenom);

            //Если числитель и знаменатель есть - прибавляем их к дроби
            if (fractEnum != 0 && fractDenom != 0)
            {
                if (enumerator == 0 && denominator == 0)
                {
                    enumerator = fractEnum;
                    denominator = fractDenom;
                    return;
                }
                else
                {
                    //Сложили числители с учетом общего знаменателя
                    //1/2 + 1/3 enumerator = 1 * 3 + 1 * 2 = 5
                    enumerator = enumerator * fractDenom + fractEnum * denominator;
                    //Находим общий знаменатель и сокращаем дробь
                    //1/2 + 1/3 demo = 6
                    denominator *= fractDenom;
                    int divider = 2;

                    //Сокращаем, пока число, на которое мы сокращаем - меньше знаменателя
                    while (divider <= denominator)
                    {
                        if ((enumerator % divider == 0) && (denominator % divider == 0))
                        {
                            enumerator /= divider;
                            denominator /= divider;
                            continue;
                        }
                        divider++;
                    }
                }
            }

        }
    }

    //Возвращаем символьное представление имеющейся дроби
    public SqlString getFraction() => new SqlString(enumerator.ToString() + "/" + denominator.ToString());
}
