Imports System.Data
Imports System.Data.SqlClient
Imports capaDatos

Namespace capaNegocio

    Public Class clsProducto

        Public Function listarIdNombre(ByVal dato As String) As DataTable
            Dim datoI As Integer = 0
            Dim datoS As String = "*"
            Dim temp As Integer
            If Integer.TryParse(dato, temp) Then
                datoI = temp
            Else
                datoS = dato
            End If
            Dim strSQL As String =
                "SELECT pr.idproducto, pr.producto, pr.stock, pr.vigencia, pr.precioactual," &
                " pm.marcaproducto, tp.tipoproducto" &
                " FROM producto pr" &
                " INNER JOIN marca_producto pm ON pm.idmarcaproducto = pr.idmarcaproducto" &
                " INNER JOIN tipo_producto tp ON tp.idtipoproducto = pr.idtipoproducto" &
                " WHERE pr.vigencia = 1 AND (pr.idproducto = " & datoI & " OR pr.producto LIKE '%" & datoS & "%')" &
                " ORDER BY 1"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            Catch ex As Exception
                Throw New Exception("Error al listar productos: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Function listarDadosDeBaja() As DataTable
            Dim strSQL As String =
                "SELECT pr.idproducto, pr.producto, pr.stock, pr.vigencia, pr.precioactual," &
                " pm.marcaproducto, tp.tipoproducto" &
                " FROM producto pr" &
                " INNER JOIN marca_producto pm ON pm.idmarcaproducto = pr.idmarcaproducto" &
                " INNER JOIN tipo_producto tp ON tp.idtipoproducto = pr.idtipoproducto" &
                " WHERE pr.vigencia = 0" &
                " ORDER BY 1"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            Catch ex As Exception
                Throw New Exception("Error al listar productos dados de baja: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Function buscarXid(ByVal id As Integer) As DataRow
            Dim strSQL As String =
                "SELECT pr.idproducto, pr.producto, pr.stock, pr.vigencia, pr.precioactual," &
                " pm.marcaproducto, tp.tipoproducto" &
                " FROM producto pr" &
                " INNER JOIN marca_producto pm ON pm.idmarcaproducto = pr.idmarcaproducto" &
                " INNER JOIN tipo_producto tp ON tp.idtipoproducto = pr.idtipoproducto" &
                " WHERE pr.idproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count > 0 Then Return dt.Rows(0)
            Catch ex As Exception
                Throw New Exception("Error al buscar producto por ID: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
            Return Nothing
        End Function

        Public Function generarCodigoProducto() As Integer
            Dim strSQL As String = "SELECT COALESCE(MAX(idproducto), 0) + 1 AS codigo FROM producto"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Throw New Exception("Error al generar código de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Sub registrarProducto(ByVal id As Integer, ByVal nombre As String, ByVal stock As Integer,
                                      ByVal vigencia As Boolean, ByVal precio As Decimal,
                                      ByVal idTipoProducto As Integer, ByVal idMarcaProducto As Integer)
            Dim strSQL As String =
                "INSERT INTO producto (producto, stock, vigencia, precioactual, idmarcaproducto, idtipoproducto)" &
                " VALUES (@producto, @stock, @vigencia, @precio, @idMarca, @idTipo)"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.Parameters.AddWithValue("@producto", nombre)
                cmd.Parameters.AddWithValue("@stock", stock)
                cmd.Parameters.AddWithValue("@vigencia", vigencia)
                cmd.Parameters.AddWithValue("@precio", precio)
                cmd.Parameters.AddWithValue("@idMarca", idMarcaProducto)
                cmd.Parameters.AddWithValue("@idTipo", idTipoProducto)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al registrar producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub modificarProducto(ByVal id As Integer, ByVal nombre As String, ByVal stock As Integer,
                                      ByVal vigencia As Boolean, ByVal precio As Decimal,
                                      ByVal idTipoProducto As Integer, ByVal idMarcaProducto As Integer)
            Dim strSQL As String =
                "UPDATE producto SET producto = @producto, stock = @stock," &
                " vigencia = @vigencia, precioactual = @precio," &
                " idmarcaproducto = @idMarca, idtipoproducto = @idTipo" &
                " WHERE idproducto = @id"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.Parameters.AddWithValue("@producto", nombre)
                cmd.Parameters.AddWithValue("@stock", stock)
                cmd.Parameters.AddWithValue("@vigencia", vigencia)
                cmd.Parameters.AddWithValue("@precio", precio)
                cmd.Parameters.AddWithValue("@idMarca", idMarcaProducto)
                cmd.Parameters.AddWithValue("@idTipo", idTipoProducto)
                cmd.Parameters.AddWithValue("@id", id)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al modificar producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub eliminarProducto(ByVal id As Integer)
            Dim objConectar As New clsConectaBD()
            objConectar.conectar()
            Dim trans As SqlTransaction = objConectar.miConexion.BeginTransaction()
            Try
                Dim cmd1 As New SqlCommand("DELETE FROM detalle_venta WHERE idproducto = " & id, objConectar.miConexion, trans)
                cmd1.ExecuteNonQuery()
                Dim cmd2 As New SqlCommand("DELETE FROM producto WHERE idproducto = " & id, objConectar.miConexion, trans)
                cmd2.ExecuteNonQuery()
                trans.Commit()
            Catch ex As Exception
                trans.Rollback()
                Throw New Exception("Error al eliminar producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub darbajaProducto(ByVal id As Integer)
            Dim strSQL As String = "UPDATE producto SET vigencia = 0 WHERE idproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al dar de baja el producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub recuperarProducto(ByVal id As Integer)
            Dim strSQL As String = "UPDATE producto SET vigencia = 1 WHERE idproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al recuperar el producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        ' ══════════════════════════════════════════════
        '  SECCIÓN VENTAS
        ' ══════════════════════════════════════════════
        Public Function listarTipoProducto() As DataTable
            Dim strSQL As String = "SELECT tipoproducto FROM tipo_producto"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            Catch ex As Exception
                Throw New Exception("Error al listar tipos de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Function listarProductosPorTipoProducto(ByVal tipoProducto As String) As DataTable
            Dim strSQL As String =
                "SELECT p.idproducto, p.producto, tp.tipoproducto, mp.marcaproducto, p.precioactual, p.stock" &
                " FROM producto p" &
                " INNER JOIN tipo_producto tp ON p.idtipoproducto = tp.idtipoproducto" &
                " INNER JOIN marca_producto mp ON p.idmarcaproducto = mp.idmarcaproducto" &
                " WHERE tp.tipoproducto = '" & tipoProducto & "'" &
                " ORDER BY p.idproducto"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            Catch ex As Exception
                Throw New Exception("Error al listar productos por tipo: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Function listarProductosGeneralesPorTipoProducto() As DataTable
            Dim strSQL As String =
                "SELECT p.idproducto, p.producto, tp.tipoproducto, mp.marcaproducto, p.precioactual, p.stock" &
                " FROM producto p" &
                " INNER JOIN tipo_producto tp ON p.idtipoproducto = tp.idtipoproducto" &
                " INNER JOIN marca_producto mp ON p.idmarcaproducto = mp.idmarcaproducto" &
                " ORDER BY p.idproducto"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            Catch ex As Exception
                Throw New Exception("Error al listar productos generales: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Sub Aumentar_DisminuirStock(ByVal cantidad As Integer, ByVal codProducto As Integer, ByVal valor As String)
            Dim strSQL As String
            If valor.ToUpper() = "AUMENTAR" Then
                strSQL = "UPDATE producto SET stock = stock + " & cantidad & " WHERE idproducto = " & codProducto
            ElseIf valor.ToUpper() = "DISMINUIR" Then
                strSQL = "UPDATE producto SET stock = stock - " & cantidad & " WHERE idproducto = " & codProducto
            Else
                Throw New Exception("Valor no válido. Use 'AUMENTAR' o 'DISMINUIR'.")
            End If
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al modificar stock: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

    End Class

End Namespace
