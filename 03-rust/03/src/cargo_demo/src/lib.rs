// Корень библиотечного crate: модуль geometry лежит в src/geometry.rs
pub mod geometry;

pub use geometry::dist; // реэкспорт: снаружи доступно как cargo_demo::dist
