Imports System.Data
Imports System.Data.SqlClient
Imports capaDatos

Namespace capaNegocio

    Public Class clsTipoProducto

        Public Function listarTipoProducto() As DataTable
            Dim strSQL As String = "SELECT * FROM tipo_producto ORDER BY 1 DESC"
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

        Public Function buscarXid(ByVal id As Integer) As DataRow
            Dim strSQL As String = "SELECT * FROM tipo_producto WHERE idtipoproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count > 0 Then Return dt.Rows(0)
            Catch ex As Exception
                Throw New Exception("Error al buscar tipo de producto por ID: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
            Return Nothing
        End Function

        Public Function buscarIdxNombre(ByVal nombre As String) As DataRow
            Dim strSQL As String = "SELECT idtipoproducto FROM tipo_producto WHERE tipoproducto LIKE '%" & nombre & "%'"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count > 0 Then Return dt.Rows(0)
            Catch ex As Exception
                Throw New Exception("Error al buscar ID por nombre de tipo de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
            Return Nothing
        End Function

        Public Function generarCodigoTipoProducto() As Integer
            Dim strSQL As String = "SELECT COALESCE(MAX(idtipoproducto), 0) + 1 AS codigo FROM tipo_producto"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Throw New Exception("Error al generar código de tipo de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Sub registrarTipoProducto(ByVal id As Integer, ByVal nombre As String)
            Dim strSQL As String = "INSERT INTO tipo_producto (idtipoproducto, tipoproducto) VALUES (" & id & ", '" & nombre & "')"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al registrar tipo de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub modificarTipoProducto(ByVal id As Integer, ByVal nombre As String)
            Dim strSQL As String = "UPDATE tipo_producto SET tipoproducto = '" & nombre & "' WHERE idtipoproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al modificar tipo de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub eliminarTipoProducto(ByVal id As Integer)
            Dim strSQL As String = "DELETE FROM tipo_producto WHERE idtipoproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al eliminar tipo de producto: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

    End Class

End Namespace
