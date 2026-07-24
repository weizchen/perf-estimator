; ModuleID = 'ofa_module'
source_filename = "ofa_module"

declare ptr @_mlir_memref_to_llvm_alloc(i64)

declare void @memrefCopy(i64, ptr, ptr)

declare void @float32tofloat8(ptr addrspace(32), ptr addrspace(8), i64)

declare void @ofa_dispatch_thread_join(i64)

declare i64 @ofa_dispatch_thread_create(i64, i64, ptr, ptr)

declare void @dispatch_kernel_matmul_me_f8_2d(ptr, i64, i64, i64, i64, i64, ptr, i64, i64, i64, i64, i64, ptr, i64, i64, i64, i64, i64)

define void @kernel(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20, ptr %21, ptr %22, i64 %23, i64 %24, i64 %25, i64 %26, i64 %27) {
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %21, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, ptr %22, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %23, 2
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %24, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %26, 4, 0
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %25, 3, 1
  %35 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, i64 %27, 4, 1
  %36 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %14, 0
  %37 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %36, ptr %15, 1
  %38 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %37, i64 %16, 2
  %39 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %38, i64 %17, 3, 0
  %40 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %39, i64 %19, 4, 0
  %41 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %40, i64 %18, 3, 1
  %42 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %41, i64 %20, 4, 1
  %43 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %7, 0
  %44 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %43, ptr %8, 1
  %45 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %44, i64 %9, 2
  %46 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %45, i64 %10, 3, 0
  %47 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %46, i64 %12, 4, 0
  %48 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %47, i64 %11, 3, 1
  %49 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %48, i64 %13, 4, 1
  %50 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %51 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %50, ptr %1, 1
  %52 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %51, i64 %2, 2
  %53 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %52, i64 %3, 3, 0
  %54 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %53, i64 %5, 4, 0
  %55 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, i64 %4, 3, 1
  %56 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %55, i64 %6, 4, 1
  %57 = alloca { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, align 8
  %58 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %57, i32 0, i32 0
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, ptr %58, align 8
  %59 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %57, i32 0, i32 1
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, ptr %59, align 8
  %60 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %57, i32 0, i32 2
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %56, ptr %60, align 8
  %61 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %57, i32 0, i32 3
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %49, ptr %61, align 8
  %62 = call i64 @ofa_dispatch_thread_create(i64 0, i64 0, ptr @__dispatch_thread_entry_kernel_dispatch_worker_0_0, ptr %57)
  call void @ofa_dispatch_thread_join(i64 %62)
  ret void
}

define void @kernel_dispatch_worker_0_0(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20, ptr %21, ptr %22, i64 %23, i64 %24, i64 %25, i64 %26, i64 %27) {
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %21, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, ptr %22, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %23, 2
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %24, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %26, 4, 0
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %25, 3, 1
  %35 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, i64 %27, 4, 1
  %36 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %14, 0
  %37 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %36, ptr %15, 1
  %38 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %37, i64 %16, 2
  %39 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %38, i64 %17, 3, 0
  %40 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %39, i64 %19, 4, 0
  %41 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %40, i64 %18, 3, 1
  %42 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %41, i64 %20, 4, 1
  %43 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %7, 0
  %44 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %43, ptr %8, 1
  %45 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %44, i64 %9, 2
  %46 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %45, i64 %10, 3, 0
  %47 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %46, i64 %12, 4, 0
  %48 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %47, i64 %11, 3, 1
  %49 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %48, i64 %13, 4, 1
  %50 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %51 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %50, ptr %1, 1
  %52 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %51, i64 %2, 2
  %53 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %52, i64 %3, 3, 0
  %54 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %53, i64 %5, 4, 0
  %55 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %54, i64 %4, 3, 1
  %56 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %55, i64 %6, 4, 1
  %57 = call ptr @llvm.stacksave.p0()
  %58 = alloca { ptr, ptr, i64, [2 x i64], [2 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %56, ptr %58, align 8
  %59 = insertvalue { i64, ptr } { i64 2, ptr poison }, ptr %58, 1
  %60 = alloca { ptr, ptr, i64, [2 x i64], [2 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [2 x i64], [2 x i64] } %49, ptr %60, align 8
  %61 = insertvalue { i64, ptr } { i64 2, ptr poison }, ptr %60, 1
  %62 = alloca { i64, ptr }, i64 1, align 8
  store { i64, ptr } %59, ptr %62, align 8
  %63 = alloca { i64, ptr }, i64 1, align 8
  store { i64, ptr } %61, ptr %63, align 8
  call void @memrefCopy(i64 4, ptr %62, ptr %63)
  call void @llvm.stackrestore.p0(ptr %57)
  %64 = call ptr @_mlir_memref_to_llvm_alloc(i64 262144)
  %65 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %64, 0
  %66 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %65, ptr %64, 1
  %67 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %66, i64 0, 2
  %68 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %67, i64 64, 3, 0
  %69 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %68, i64 4096, 3, 1
  %70 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %69, i64 4096, 4, 0
  %71 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %70, i64 1, 4, 1
  %72 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 1
  %73 = ptrtoint ptr %72 to i64
  %74 = inttoptr i64 %73 to ptr addrspace(32)
  %75 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %71, 1
  %76 = ptrtoint ptr %75 to i64
  %77 = inttoptr i64 %76 to ptr addrspace(8)
  call void @float32tofloat8(ptr addrspace(32) %74, ptr addrspace(8) %77, i64 262144)
  %78 = call ptr @_mlir_memref_to_llvm_alloc(i64 1048576)
  %79 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %78, 0
  %80 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %79, ptr %78, 1
  %81 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %80, i64 0, 2
  %82 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %81, i64 4096, 3, 0
  %83 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %82, i64 256, 3, 1
  %84 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %83, i64 256, 4, 0
  %85 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %84, i64 1, 4, 1
  %86 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, 1
  %87 = ptrtoint ptr %86 to i64
  %88 = inttoptr i64 %87 to ptr addrspace(32)
  %89 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %85, 1
  %90 = ptrtoint ptr %89 to i64
  %91 = inttoptr i64 %90 to ptr addrspace(8)
  call void @float32tofloat8(ptr addrspace(32) %88, ptr addrspace(8) %91, i64 1048576)
  %92 = inttoptr i64 %76 to ptr
  %93 = inttoptr i64 %90 to ptr
  %94 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %49, 1
  %95 = ptrtoint ptr %94 to i64
  %96 = inttoptr i64 %95 to ptr
  call void @dispatch_kernel_matmul_me_f8_2d(ptr %92, i64 0, i64 64, i64 4096, i64 4096, i64 1, ptr %93, i64 0, i64 4096, i64 256, i64 256, i64 1, ptr %96, i64 0, i64 64, i64 256, i64 256, i64 1)
  ret void
}

define void @__dispatch_thread_entry_kernel_dispatch_worker_0_0(ptr %0) {
  %2 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 0
  %3 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %2, align 8
  %4 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 1
  %5 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %4, align 8
  %6 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 2
  %7 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %6, align 8
  %8 = getelementptr { { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] }, { ptr, ptr, i64, [2 x i64], [2 x i64] } }, ptr %0, i32 0, i32 3
  %9 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %8, align 8
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 1
  %12 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 2
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 0
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 1
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 0
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 1
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 0
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 1
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 2
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 3, 0
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 3, 1
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 4, 0
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, 4, 1
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 0
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 1
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 2
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 3, 0
  %28 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 3, 1
  %29 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 4, 0
  %30 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, 4, 1
  %31 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 0
  %32 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 1
  %33 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 2
  %34 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 3, 0
  %35 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 3, 1
  %36 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 4, 0
  %37 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, 4, 1
  call void @kernel_dispatch_worker_0_0(ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, i64 %15, i64 %16, ptr %17, ptr %18, i64 %19, i64 %20, i64 %21, i64 %22, i64 %23, ptr %24, ptr %25, i64 %26, i64 %27, i64 %28, i64 %29, i64 %30, ptr %31, ptr %32, i64 %33, i64 %34, i64 %35, i64 %36, i64 %37)
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave.p0() #0

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore.p0(ptr) #0

attributes #0 = { nocallback nofree nosync nounwind willreturn }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
