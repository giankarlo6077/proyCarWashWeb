Imports System.Data
Imports System.Data.SqlClient
Imports capaDatos

Namespace capaNegocio

    Public Class clsMarca

        Public Function listarMarca() As DataTable
            Dim strSQL As String = "SELECT * FROM marca_producto ORDER BY 1 ASC"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            Catch ex As Exception
                Throw New Exception("Error al listar marcas: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Function buscarXid(ByVal id As Integer) As DataRow
            Dim strSQL As String = "SELECT * FROM marca_producto WHERE idmarcaproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count > 0 Then Return dt.Rows(0)
            Catch ex As Exception
                Throw New Exception("Error al buscar marca por ID: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
            Return Nothing
        End Function

        Public Function buscaridxNombre(ByVal nombre As String) As DataRow
            Dim strSQL As String = "SELECT idmarcaproducto FROM marca_producto WHERE marcaproducto LIKE '%" & nombre & "%'"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim da As New SqlDataAdapter(strSQL, objConectar.miConexion)
                Dim dt As New DataTable()
                da.Fill(dt)
                If dt.Rows.Count > 0 Then Return dt.Rows(0)
            Catch ex As Exception
                Throw New Exception("Error al buscar ID por nombre de marca: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
            Return Nothing
        End Function

        Public Function generarCodigoMarca() As Integer
            Dim strSQL As String = "SELECT COALESCE(MAX(idmarcaproducto), 0) + 1 AS codigo FROM marca_producto"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            Catch ex As Exception
                Throw New Exception("Error al generar código de marca: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Function

        Public Sub registrarMarca(ByVal id As Integer, ByVal nombre As String)
            Dim strSQL As String = "INSERT INTO marca_producto (idmarcaproducto, marcaproducto) VALUES (" & id & ", '" & nombre & "')"
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al registrar marca: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub modificarMarca(ByVal id As Integer, ByVal nombre As String)
            Dim strSQL As String = "UPDATE marca_producto SET marcaproducto = '" & nombre & "' WHERE idmarcaproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al modificar marca: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

        Public Sub eliminarMarca(ByVal id As Integer)
            Dim strSQL As String = "DELETE FROM marca_producto WHERE idmarcaproducto = " & id
            Dim objConectar As New clsConectaBD()
            Try
                objConectar.conectar()
                Dim cmd As New SqlCommand(strSQL, objConectar.miConexion)
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw New Exception("Error al eliminar marca: " & ex.Message)
            Finally
                objConectar.desconectar()
            End Try
        End Sub

    End Class

End Namespace
