//
//  JwtServiceMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto
@testable import VCL

class JwtServiceMocks {
    
    static let AdamSmithDriversLicenseJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo2NzYyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIkRyaXZlcnNMaWNlbnNlVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdGF0dXMiOnsidHlwZSI6IlZlbG9jaXR5UmV2b2NhdGlvbkxpc3RKYW4yMDIxIiwiaWQiOiJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTIxMDMiLCJzdGF0dXNMaXN0SW5kZXgiOjIxMDMsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiZXRoZXJldW06MHhEODkwRjJENjBCNDI5ZjllMjU3RkMwQmM1OEVmMjIzNzc3NkREOTFCL2dldFJldm9rZWRTdGF0dXM_YWRkcmVzcz0weDAzMDE4RTNhMzg5NzM0YUUxMmYxNEU0NDU0MGZBZWEzNTc5MWZFQzcmbGlzdElkPTE2MzU3ODg2NjI5NjY1MyIsImxpbmtDb2RlQ29tbWl0IjoiRWlBSVkxWHdaZzV4cnZvUk5jNE55d3JBcVhrV2pZU05MVTM2dDlQQ0dzbDQ5dz09In0sImNvbnRlbnRIYXNoIjp7InR5cGUiOiJWZWxvY2l0eUNvbnRlbnRIYXNoMjAyMCIsInZhbHVlIjoiZTkwN2Y1NDc2YzU3ZTczNDIzZjFjOWIzOTNiYzFkMGE0ZDU2MjgwYWMxNTUzOTZjYzg3OWYyNDQxYTUyM2NkYyJ9LCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9kcml2ZXJzLWxpY2Vuc2UtdjEuMC5zY2hlbWEuanNvbiIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJuYW1lOiI6IkNhbGlmb3JuaWEgRHJpdmVyIExpY2Vuc2UiLCJhdXRob3JpdHkiOnsibmFtZSI6IkNhbGlmb3JuaWEgRE1WIiwicGxhY2UiOnsiYWRkcmVzc1JlZ2lvbiI6IkNBIiwiYWRkcmVzc0NvdW50cnkiOiJVUyJ9fSwidmFsaWRpdHkiOnsidmFsaWRGcm9tIjoiMjAxNS0wMi0wMSIsInZhbGlkVW50aWwiOiIyMDI1LTAxLTMwIn0sImlkZW50aWZpZXIiOiIxMjMxMDMxMjMxMiIsInBlcnNvbiI6eyJnaXZlbk5hbWUiOiJBZGFtIiwiZmFtaWx5TmFtZSI6IlNtaXRoIiwiYmlydGhEYXRlIjoiMTk2Ni0wNi0yMCIsImdlbmRlciI6Ik1hbGUifX19LCJpc3MiOiJkaWQ6aW9uOkVpQWVoV21wWDVtSEJ1YzkzU0loUFhGOGJzRXg2OEc2bVBjZElhTE5HYm96UEEiLCJqdGkiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo2NzYyIiwiaWF0IjoxNjUyODk2ODY5LCJuYmYiOjE2NTI4OTY4Njl9.DYSJseMcm31Odj7tncT_HBRMs5mknBBRgWuAranmKuY1MPQoBG-A0qOOI9Q3z8X78B7sJISE5iAXBkaVKjUJ2w"
    static let AdamSmithPhoneJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo5MTg1I2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.ewogICJ2YyI6IHsKICAgICJAY29udGV4dCI6IFsKICAgICAgImh0dHBzOi8vd3d3LnczLm9yZy8yMDE4L2NyZWRlbnRpYWxzL3YxIgogICAgXSwKICAgICJ0eXBlIjogWwogICAgICAiUGhvbmVWMS4wIiwKICAgICAgIlZlcmlmaWFibGVDcmVkZW50aWFsIgogICAgXSwKICAgICJjcmVkZW50aWFsU3RhdHVzIjogewogICAgICAidHlwZSI6ICJWZWxvY2l0eVJldm9jYXRpb25MaXN0SmFuMjAyMSIsCiAgICAgICJpZCI6ICJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTU3OTkiLAogICAgICAic3RhdHVzTGlzdEluZGV4IjogNTc5OSwKICAgICAgInN0YXR1c0xpc3RDcmVkZW50aWFsIjogImV0aGVyZXVtOjB4RDg5MEYyRDYwQjQyOWY5ZTI1N0ZDMEJjNThFZjIyMzc3NzZERDkxQi9nZXRSZXZva2VkU3RhdHVzP2FkZHJlc3M9MHgwMzAxOEUzYTM4OTczNGFFMTJmMTRFNDQ1NDBmQWVhMzU3OTFmRUM3Jmxpc3RJZD0xNjM1Nzg4NjYyOTY2NTMiLAogICAgICAibGlua0NvZGVDb21taXQiOiAiRWlCaXlISE1LRlkwYW1rK3gvVGxtN2liY2tsbk8wbHMySEh1ckozN09WRDBJZz09IgogICAgfSwKICAgICJjb250ZW50SGFzaCI6IHsKICAgICAgInR5cGUiOiAiVmVsb2NpdHlDb250ZW50SGFzaDIwMjAiLAogICAgICAidmFsdWUiOiAiNGYwMjUyYzRlMTI4ZTZkMzE5N2NlYTA3Yjc2ZmNiYWExMjZkZTNkNDBiZjY1NzlkZmE1MzQ1ZTVjZjFhOGZiMiIKICAgIH0sCiAgICAiY3JlZGVudGlhbFNjaGVtYSI6IHsKICAgICAgImlkIjogImh0dHBzOi8vZGV2cmVnaXN0cmFyLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvcGhvbmUtdjEuMC5zY2hlbWEuanNvbiIsCiAgICAgICJ0eXBlIjogIkpzb25TY2hlbWFWYWxpZGF0b3IyMDE4IgogICAgfSwKICAgICJjcmVkZW50aWFsU3ViamVjdCI6IHsKICAgICAgInBob25lIjogIisxNTU1NjE5MjE5MSIsCiAgICAgICJmb28iOiAiZm9vIgogICAgfQogIH0sCiAgImlzcyI6ICJkaWQ6aW9uOkVpQWVoV21wWDVtSEJ1YzkzU0loUFhGOGJzRXg2OEc2bVBjZElhTE5HYm96UEEiLAogICJqdGkiOiAiZGlkOnZlbG9jaXR5OnYyOjB4NjI1NmIxODkyMWVhYmQzOTM1MWVjMjNmMWM5NGY4ODA2MDRlNzBlNzoyMTE0ODg3MTgzNTUwMDg6OTE4NSIsCiAgImlhdCI6IDE2NTI4OTY4NjksCiAgIm5iZiI6IDE2NTI4OTY4NjkKfQ.aiiqintVpgfn1GpSJG8lSRlLqr2K0rfylXDd92ryzBgLEsS-8CbFngNHIHJYW9SVgiJYXcPv6f0YZMk78cYPtw"
    static let AdamSmithEmailJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo0MTY2I2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIkVtYWlsVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdGF0dXMiOnsidHlwZSI6IlZlbG9jaXR5UmV2b2NhdGlvbkxpc3RKYW4yMDIxIiwiaWQiOiJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTg2OTgiLCJzdGF0dXNMaXN0SW5kZXgiOjg2OTgsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiZXRoZXJldW06MHhEODkwRjJENjBCNDI5ZjllMjU3RkMwQmM1OEVmMjIzNzc3NkREOTFCL2dldFJldm9rZWRTdGF0dXM_YWRkcmVzcz0weDAzMDE4RTNhMzg5NzM0YUUxMmYxNEU0NDU0MGZBZWEzNTc5MWZFQzcmbGlzdElkPTE2MzU3ODg2NjI5NjY1MyIsImxpbmtDb2RlQ29tbWl0IjoiRWlBb3FJWWYycmgxdzEvdURXTnNwYTRyOHRrV2dwRGRUUjBtNHlIRTVMZUtQZz09In0sImNvbnRlbnRIYXNoIjp7InR5cGUiOiJWZWxvY2l0eUNvbnRlbnRIYXNoMjAyMCIsInZhbHVlIjoiODlkNGRjYzg2ZDU0MGM2ZWVhMzlkMTc4ZWVkYzMwMjEzZTc4MmYyNTFlMDNiNzZmNDI3MzEwNjgwOGRkMGQ0ZiJ9LCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9lbWFpbC12MS4wLnNjaGVtYS5qc29uIiwidHlwZSI6Ikpzb25TY2hlbWFWYWxpZGF0b3IyMDE4In0sImNyZWRlbnRpYWxTdWJqZWN0Ijp7ImVtYWlsIjoiYWRhbS5zbWl0aEBleGFtcGxlLmNvbSJ9fSwiaXNzIjoiZGlkOmlvbjpFaUFlaFdtcFg1bUhCdWM5M1NJaFBYRjhic0V4NjhHNm1QY2RJYUxOR2JvelBBIiwianRpIjoiZGlkOnZlbG9jaXR5OnYyOjB4NjI1NmIxODkyMWVhYmQzOTM1MWVjMjNmMWM5NGY4ODA2MDRlNzBlNzoyMTE0ODg3MTgzNTUwMDg6NDE2NiIsImlhdCI6MTY1Mjg5Njg2OSwibmJmIjoxNjUyODk2ODY5fQ.fi0qJFzHiDEWTGUu0ME1aG36-j2jm7xxA2DWPs_Ra7ftl-ALMu0FY3A38klbkJQYCaXWHFH0hBbcQ5Z3uZCeew"

    static let PresentationRequestJwt = "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6MHhkNjAyMzFhM2QwZGUwZjE5N2YxNzg0ZjZmMzdlYmNmYWEyOTFhYjIzI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJleGNoYW5nZV9pZCI6IjYwODk2NDViNDY2N2M4NDQ5YzQzM2EwMSIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiR29vZ2xlIiwibG9nb191cmkiOiJodHRwczovL2V4cHJlc3N3cml0ZXJzLmNvbS93cC1jb250ZW50L3VwbG9hZHMvMjAxNS8wOS9nb29nbGUtbmV3LWxvZ28tMTI4MHg3MjAuanBnIiwidG9zX3VyaSI6Imh0dHBzOi8vcmVxdWlzaXRpb25zLmFjbWUuZXhhbXBsZS5jb20vZGlzY2xvc3VyZS10ZXJtcy5odG1sIiwibWF4X3JldGVudGlvbl9wZXJpb2QiOiIybSJ9LCJwcmVzZW50YXRpb25fZGVmaW5pdGlvbiI6eyJpZCI6IjYwODk2NDViNDY2N2M4NDQ5YzQzM2EwMS41ZjRkN2VjOTQ2MTE3MDAwMDc0OWNmNzUiLCJwdXJwb3NlIjoiSm9iIG9mZmVyIiwiZm9ybWF0Ijp7Imp3dF92cCI6eyJhbGciOlsic2VjcDI1NmsxIl19fSwiaW5wdXRfZGVzY3JpcHRvcnMiOlt7ImlkIjoiSWRlbnRpdHlBbmRDb250YWN0Iiwic2NoZW1hIjpbeyJ1cmkiOiJJZGVudGl0eUFuZENvbnRhY3QifV19LHsiaWQiOiJFZHVjYXRpb25EZWdyZWUiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvZWR1Y2F0aW9uLWRlZ3JlZS5zY2hlbWEuanNvbiJ9XX0seyJpZCI6IlBhc3RFbXBsb3ltZW50UG9zaXRpb24iLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvcGFzdC1lbXBsb3ltZW50LXBvc2l0aW9uLnNjaGVtYS5qc29uIn1dfSx7ImlkIjoiQ3VycmVudEVtcGxveW1lbnRQb3NpdGlvbiIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9jdXJyZW50LWVtcGxveW1lbnQtcG9zaXRpb24uc2NoZW1hLmpzb24ifV19LHsiaWQiOiJDZXJ0aWZpY2F0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL2NlcnRpZmljYXRpb24uc2NoZW1hLmpzb24ifV19LHsiaWQiOiJCYWRnZSIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9iYWRnZS5zY2hlbWEuanNvbiJ9XX0seyJpZCI6IkFzc2Vzc21lbnQiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvYXNzZXNzbWVudC5zY2hlbWEuanNvbiJ9XX1dfSwiaXNzIjoiZGlkOnZlbG9jaXR5OjB4ZDYwMjMxYTNkMGRlMGYxOTdmMTc4NGY2ZjM3ZWJjZmFhMjkxYWIyMyIsImlhdCI6MTYxOTYxNjg1OSwiZXhwIjoxNjIwMjIxNjU5LCJuYmYiOjE2MTk2MTY4NTl9.r6n0nwB6iTrNEEokE63fSmKIS350t_giHp8LvZLmG66ESFZHodAStTowaiHOObJr-la2Uy8uXqtQLlTBO37SGQ"
    
    static let SignedJwt = "eyJ0eXAiOiJKV1QiLCJqd2siOnsiY3J2Ijoic2VjcDI1NmsxIiwieCI6Iks2Q1Q0LXZrOWF4Nm9jWFhuVGtwaGJVeXAxTVU5TFdFN2FxWkFkYW1kYlEiLCJ5IjoiUjgwODNkdGRiTXo2c3hFNEhuZDdKR0lPQnRMbFZRbFM3MXY4MnhxamVJSSIsImt0eSI6IkVDIiwia2lkIjoicFZrc2htdlZRY0NRRGppRnhBS3JtXy1KQ0FMRGx1TW56UXlESFY2UWdCayIsImFsZyI6IkVTMjU2SyIsInVzZSI6InNpZyJ9LCJhbGciOiJFUzI1NksifQ.eyJpZCI6IjEwNzY3QzM2LTIwREQtNDBDMS05RTlGLUM2NzUxOUJFRTBENCIsInZwIjp7InByZXNlbnRhdGlvbl9zdWJtaXNzaW9uIjp7ImlkIjoiMTI2RjlENzItNEMxMy00QzY5LUFGQjQtODk2NTU1RjM3Qjc1IiwiZGVmaW5pdGlvbl9pZCI6IjYwOTJiMTY0NjM0MjNmNjM2OWU4NDFkYS41ZjRkN2VjOTQ2MTE3MDAwMDc0OWNmNzUiLCJkZXNjcmlwdG9yX21hcCI6W3sicGF0aCI6IiQudmVyaWZpYWJsZUNyZWRlbnRpYWxbMF0iLCJmb3JtYXQiOiJqd3RfdmMiLCJpZCI6IklkRG9jdW1lbnQifSx7InBhdGgiOiIkLnZlcmlmaWFibGVDcmVkZW50aWFsWzFdIiwiZm9ybWF0Ijoiand0X3ZjIiwiaWQiOiJDdXJyZW50RW1wbG95bWVudFBvc2l0aW9uIn1dfSwidHlwZSI6IlZlcmlmaWFibGVQcmVzZW50YXRpb24iLCJ2ZXJpZmlhYmxlQ3JlZGVudGlhbCI6WyJleUowZVhBaU9pSktWMVFpTENKcWQyc2lPbnNpWTNKMklqb2ljMlZqY0RJMU5tc3hJaXdpZUNJNkltNUVSbVpOWWxKcVdIZEhXVlpvTTI1MlYzWkxPRE0zUlRKSWNsWlpXVGxZVUZocFpsVnpUR1JDYTJzaUxDSjVJam9pVVhKdVRVOXphbFphWVcxeWIyVlBWRTUyV0VrMk0zbFpSV295YlRGaWRscFpabVJ5TTBWSWMxUkxUU0lzSW10MGVTSTZJa1ZESWl3aWEybGtJam9pUkhkYVkxZFVZbGhsUWxaS05sVk9jRkZhWW1WTExXOHlXV2hZTWtaVk4wSk1VMHhzVlhsVGFVNDVPQ0lzSW1Gc1p5STZJa1ZUTWpVMlN5SXNJblZ6WlNJNkluTnBaeUo5TENKaGJHY2lPaUpGVXpJMU5rc2lmUS5leUoyWXlJNmV5SkFZMjl1ZEdWNGRDSTZXeUpvZEhSd2N6b3ZMM2QzZHk1M015NXZjbWN2TWpBeE9DOWpjbVZrWlc1MGFXRnNjeTkyTVNKZExDSjBlWEJsSWpwYklsQm9iMjVsSWl3aVZtVnlhV1pwWVdKc1pVTnlaV1JsYm5ScFlXd2lYU3dpWTNKbFpHVnVkR2xoYkZOMFlYUjFjeUk2ZXlKcFpDSTZJbWgwZEhCek9pOHZZM0psWkdWdWRHbGhiSE4wWVhSMWN5NTJaV3h2WTJsMGVXTmhjbVZsY214aFluTXVhVzhpTENKMGVYQmxJam9pVm1Wc2IyTnBkSGxTWlhadlkyRjBhVzl1VW1WbmFYTjBjbmtpZlN3aVkzSmxaR1Z1ZEdsaGJGTjFZbXBsWTNRaU9uc2ljR2h2Ym1VaU9pSXJORFF3TURFeE1qSXpNelEwSW4xOUxDSnBjM01pT2lKa2FXUTZkbVZzYjJOcGRIazZNSGc1TnpNME5tUXhNMkpoT1RBellXWmxaVEV5TnpVM05UbGlZamszTVdRMFpEWTFNRFUzTW1GbElpd2lhblJwSWpvaVpHbGtPblpsYkc5amFYUjVPakI0Wm1RNFltUXlOREZqTXpnMU1UQTFNRGsxTVRVell6VmpaRFEwWXpRek9HTTNZVGczWm1ZMk55SXNJbWxoZENJNk1UWXhOemc0TXpJME1pd2libUptSWpveE5qRTNPRGd6TWpReWZRLkFKUTRCQVZwYmpsUVZmaUQ3RUEtMjV2NF9nS2FyZGx0ZXpqd0F4OVBQQUZ2RXZOMEg4djNOcUM1SmdjcDZyLWJDYm1CZEJQWVhvNU1QOGREMDhuT0ZnIiwiZXlKMGVYQWlPaUpLVjFRaUxDSnFkMnNpT25zaVkzSjJJam9pYzJWamNESTFObXN4SWl3aWVDSTZJalpFWW0xelVYSm5hbWhOUmxBMVdVcFVNa3N5U2tScWJqSnViV3BFWjBkMGJVUTFiV1ZMVkd0RVlXTWlMQ0o1SWpvaVVGZGxiMFZhZURnNGQwSjVOVUpYYVhOVGFUZGFWV3QxZDJ0WWFFMTJTbVkwUlV4dmFqaFFORTlvWnlJc0ltdDBlU0k2SWtWRElpd2lhMmxrSWpvaVMwaHhlV3hRYjJOMGNtbFFiVEIxVm1wTE9UWnZkek5QUkc0NWEyWnhXbXhITFZNNFN6QnlORVZaYXlJc0ltRnNaeUk2SWtWVE1qVTJTeUlzSW5WelpTSTZJbk5wWnlKOUxDSmhiR2NpT2lKRlV6STFOa3NpZlEuZXlKMll5STZleUpBWTI5dWRHVjRkQ0k2V3lKb2RIUndjem92TDNkM2R5NTNNeTV2Y21jdk1qQXhPQzlqY21Wa1pXNTBhV0ZzY3k5Mk1TSmRMQ0owZVhCbElqcGJJa2xrUkc5amRXMWxiblFpTENKV1pYSnBabWxoWW14bFEzSmxaR1Z1ZEdsaGJDSmRMQ0pqY21Wa1pXNTBhV0ZzVTNSaGRIVnpJanA3SW1sa0lqb2lhSFIwY0hNNkx5OWpjbVZrWlc1MGFXRnNjM1JoZEhWekxuWmxiRzlqYVhSNVkyRnlaV1Z5YkdGaWN5NXBieUlzSW5SNWNHVWlPaUpXWld4dlkybDBlVkpsZG05allYUnBiMjVTWldkcGMzUnllU0o5TENKamNtVmtaVzUwYVdGc1UzVmlhbVZqZENJNmV5SnJhVzVrSWpvaVVHRnpjM0J2Y25RaUxDSmhkWFJvYjNKcGRIa2lPbnNpYkc5allXeHBlbVZrSWpwN0ltVnVJam9pU0UwZ1VHRnpjM0J2Y25RZ1QyWm1hV05sSW4xOUxDSnNiMk5oZEdsdmJpSTZleUpqYjNWdWRISjVRMjlrWlNJNklsVkxJaXdpY21WbmFXOXVRMjlrWlNJNklsZFRUU0o5TENKcFpHVnVkR2wwZVU1MWJXSmxjaUk2SWpFd09ERXlNelExTmpjaUxDSm1hWEp6ZEU1aGJXVWlPbnNpYkc5allXeHBlbVZrSWpwN0ltVnVJam9pUVc1a2NtVjNJbjE5TENKc1lYTjBUbUZ0WlNJNmV5SnNiMk5oYkdsNlpXUWlPbnNpWlc0aU9pSklZV3hzSW4xOUxDSmtiMklpT25zaVpHRjVJam81TENKdGIyNTBhQ0k2TVRFc0lubGxZWElpT2pFNU9UWjlMQ0oyWVd4cFpFWnliMjBpT2lJeU1ERTJMVEV3TFRNd1ZEQXdPakF3T2pBd0xqQXdNRm9pTENKMllXeHBaRlZ1ZEdsc0lqb2lNakF5TmkweE1DMHlPVlF3TURvd01Eb3dNQzR3TURCYUluMTlMQ0pwYzNNaU9pSmthV1E2ZG1Wc2IyTnBkSGs2TUhnNU56TTBObVF4TTJKaE9UQXpZV1psWlRFeU56VTNOVGxpWWprM01XUTBaRFkxTURVM01tRmxJaXdpYW5ScElqb2laR2xrT25abGJHOWphWFI1T2pCNE1qZGpObUpqTnpsaVl6SmhPV0kwT0RZeE9UTXdObUUyWkdJNVl6WTRaR013WldWbVlqRmxOeUlzSW1saGRDSTZNVFl4TnpnNE16RTBNQ3dpYm1KbUlqb3hOakUzT0Rnek1UUXdmUS5QaEE0RV91WjBHeVpxOXhFaFpxTVZFUDFHTUl5NnZBQ0lSVnBEblhTejFZREtpaERvZUl2R2dCMGtldTYwREVjNFhUNXB6UXpRX3hxU2NqNkt0Rmh4ZyJdfSwic3ViIjoiRkU0NzU4MDItRUJDNi00OEM0LTg3NDYtM0NDMzdCOEU1M0E2IiwiYXVkIjoiZGlkOnZlbG9jaXR5OjB4ZDYwMjMxYTNkMGRlMGYxOTdmMTc4NGY2ZjM3ZWJjZmFhMjkxYWIyMyIsImlzcyI6IkZFNDc1ODAyLUVCQzYtNDhDNC04NzQ2LTNDQzM3QjhFNTNBNiIsImp0aSI6IjEwNzY3QzM2LTIwREQtNDBDMS05RTlGLUM2NzUxOUJFRTBENCIsImlhdCI6MTYyMDIyNjQxOCwibmJmIjoxNjIwMjI2NDE4fQ.YfOHRGqe8oUQpflFTBqAD9QAfXn6RnfLZdjxjtR5uSv7RFVlKCLUJee-t52sHYWlmEl8-43InGmWo0loWZkWwQ"
    
    static let Json = "{ \"name\": { \"ui.title\": \"Issued by\" }, \"identifer\": { \"ui.widget\": \"hidden\" }, \"place\": { \"name\": { \"ui.widget\": \"hidden\" }, \"addressCountry\": { \"ui.title\": \"Country\", \"ui:enum\": [ \"TARGET_COUNTRIES_ENUM\" ], \"ui:enumNames\": [ \"TARGET_COUNTRIES_ENUM_NAMES\" ], \"ui:widget\": \"select\" }, \"addressRegion\": { \"ui.title\": \"State or region\", \"ui:enum\": [\"TARGET_REGIONS_ENUM\"], \"ui:enumNames\": [\"TARGET_REGIONS_ENUM_NAMES\"], \"ui:widget\": \"select\" }, \"addressLocality\": { \"ui.widget\": \"hidden\" } }, \"ui:order\": [ \"name\", \"place\" ] }"

    static let PublicJwk = VCLPublicJwk(valueStr: KeyServiceMocks.JWK)

    static let JWT = VCLJwt(encodedJwt: SignedJwt)
}
